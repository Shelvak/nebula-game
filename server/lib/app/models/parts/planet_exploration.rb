module Parts::PlanetExploration
  def self.included(receiver)
    receiver.extend ClassMethods
    receiver.send :include, InstanceMethods
  end

  module ClassMethods
  end

  module InstanceMethods
    # Sends scientists from owning +Player+ to exploration mission. _x_ and
    # _y_ must be coordinates of block tile which allows exploration.
    #
    # Scientists are deducted from +Player+ while mission is ongoing.
    #
    def explore!(x, y)
      raise GameLogicError.new("Planet must have owner to explore!") \
        if player_id.nil?
      raise GameLogicError.new("Planet is already being explored!") \
        if exploring?

      kind = tile_kind(x, y)
      raise GameLogicError.new(
        "Tile @ #{x},#{y} should have been exploration tile but was #{
          kind.inspect}!") unless Tile::EXPLORATION_TILES.include?(kind)

      player = self.player
      scientists = player.scientists
      scientists_required = Tile.exploration_scientists(kind)
      raise GameLogicError.new(
        "Player does not have enough scientists for exploring #{
          kind}! Required: #{scientists_required}, had: #{scientists}"
        ) if scientists_required > scientists

      self.exploration_x = x
      self.exploration_y = y
      ends_at = Tile.exploration_time(kind).since
      self.exploration_ends_at = ends_at
      player.scientists -= scientists_required

      transaction do
        save!
        player.save!
        CallbackManager.register(self,
          CallbackManager::EVENT_EXPLORATION_COMPLETE,
          ends_at)
        EventBroker.fire(self, EventBroker::CHANGED, 
          EventBroker::REASON_OWNER_PROP_CHANGE)
      end

      true
    end

    # Is exploration currently happening on this planet?
    def exploring?; ! exploration_ends_at.nil?; end

    # Stops exploration in this planet. Returns scientists to player,
    # nullifies exploration attributes and unregisters callback.
    #
    # If no _player_ is passed current planet owner is taken. Otherwise
    # scientists are returned to given player
    #
    def stop_exploration!(player=nil)
      raise GameLogicError.new(
        "Cannot stop exploration if not currently exploring!"
      ) unless exploring?

      kind = tile_kind(exploration_x, exploration_y)
      player ||= self.player
      raise GameLogicError.new(
        "Cannot return scientists if player is nil!"
      ) if player.nil?

      player.scientists += Tile.exploration_scientists(kind)
      self.exploration_x = nil
      self.exploration_y = nil
      self.exploration_ends_at = nil

      transaction do
        CallbackManager.unregister(self,
          CallbackManager::EVENT_EXPLORATION_COMPLETE)
        player.save!
        save!
        EventBroker.fire(self, EventBroker::CHANGED,
          EventBroker::REASON_OWNER_PROP_CHANGE)
      end
    end

    # Finishes exploration, checks if anything was found and gives out
    # rewards accordingly. Creates notification and clears exploration
    # attributes so other one can be started.
    def finish_exploration!
      width, height = Tile::BLOCK_SIZES[
        tile_kind(exploration_x, exploration_y)
      ]

      player = self.player
      win_chance = CONFIG.evalproperty("tiles.exploration.winning_chance",
        'width' => width, 'height' => height).round
      win_lose_key = Random.chance(win_chance) ? "win" : "lose"
      units_key = player.population_free > 0  ? "with_units" : "without_units"
      rewards = Rewards.from_exploration(
        (
          CONFIG["tiles.exploration.rewards.#{win_lose_key}.#{units_key}"]
        ).weighted_random { |item| item['weight'] }['rewards']
      )

      transaction do
        Objective::ExploreBlock.progress(self)
        Notification.create_for_exploration_finished(self, rewards)
        rewards.claim!(self, player)
        stop_exploration!
      end

      true
    end

    # Return tile kind for coordinates _x_, _y_.
    def tile_kind(x, y)
      Tile.where(:planet_id => id, :x => x, :y => y).first.try(:kind)
    end

    # Returns how much scientists are exploring this planet.
    def exploration_scientists
      return 0 unless exploring?

      kind = tile_kind(exploration_x, exploration_y)
      Tile.exploration_scientists(kind)
    end
  end
end
