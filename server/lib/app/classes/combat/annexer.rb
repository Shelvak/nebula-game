class Combat::Annexer
  class << self
    # Annexes a +SsObject+ if:
    # 1. It was without an owner - assign player randomly.
    # 2. It was owned - only change planet ownership to enemy player.
    #
    # If there was a combat, then calculate winners from _outcomes_ and
    # random weights from _statistics_. Otherwise these two can be nil.
    #
    def annex!(planet, status, alliances, combat_data)
      players = alliances.values.flatten
      determine_new_planet_owner(planet, status, players, combat_data)
    end

    protected

    # Protects player from losing his last planet.
    def protect(planet, old_player, new_player)
      ActiveRecord::Base.transaction do
        [old_player, new_player].each do |player|
          Notification.create_for_planet_protected(planet, player) \
            unless player.nil?
        end
        Cooldown.create_or_update!(planet,
          Cfg.planet_protection_duration.from_now)
      end
    end

    # Changes planet owner.
    def determine_new_planet_owner(planet, status, players, combat_data)
      winner = false
      old_player = planet.player

      if status == Combat::CheckReport::CONFLICT
        if combat_data.nil?
          # If no combat was ran, don't do anything
        else
          winners, weights = winners_with_weights(planet.player, players,
            combat_data)
          winner = winners.weighted_random(weights) unless winners.blank?
        end
      else
        unless old_player.nil?
          # Only transfer control of planet to an enemy or NPC.
          players = StatusResolver.new(old_player).filter(
            players, [StatusResolver::NPC, StatusResolver::ENEMY], :id)
        end

        winner = players.random_element unless players.blank?
      end

      change_planet_owner(planet, winner) unless winner == false
    end
    
    def change_planet_owner(planet, new_player)
      old_player = planet.player
      if old_player && old_player.planets_count == 1
        protect(planet, old_player, new_player)
      else
        ActiveRecord::Base.transaction do
          planet.player = new_player
          planet.save!
          Notification.create_for_planet_annexed(planet, old_player, 
            new_player)
        end
      end
    end

    # Calculate [_winners_, _weights_] for planet annexation.
    def winners_with_weights(owner, players, combat_data)
      winners = []
      weights = []
      resolver = StatusResolver.new(owner) unless owner.nil?

      players.each do |player|
        # player can be nil if it is NPC. In that case we use ID 0 because it
        # is hardcoded into SpaceMule.
        player_id = player ? player.id : nil
        # SpaceMule player id
        sm_player_id = player ? player.id.to_s : Combat::NPC_SM
        if combat_data.outcomes[sm_player_id] == Combat::OUTCOME_WIN && (
          owner.nil? || (
            status = resolver.status(player_id);
            status == StatusResolver::ENEMY ||
            status == StatusResolver::NPC
          )
        )
          winners.push player
          weights.push combat_data.statistics[sm_player_id]['points_earned']
        end
      end

      [winners, weights]
    end
  end
end