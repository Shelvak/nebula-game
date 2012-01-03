module Parts::Repairable
  def self.included(receiver)
    raise ArgumentError.new(
      "You cannot mix #{self} with Parts::WithCooldown because they both " +
        "use #cooldown_ends_at!"
    ) if receiver.include?(Parts::WithCooldown)

    receiver.send :include, InstanceMethods
    receiver.extend ClassMethods
  end

  module InstanceMethods
    def repairing?
      state == Building::STATE_REPAIRING
    end

    def check_upgrade!(*args)
      raise GameLogicError.new("Cannot upgrade building while repairing!") \
        if repairing?
      super(*args)
    end

    # Start repairs.
    def repair!
      raise GameLogicError.new("#{self} must be active for repairs!") \
        unless active?

      player = planet.player
      raise GameLogicError.new("NPCs cannot repair #{self}!") if player.nil?

      technology = Technology::BuildingRepair.
        where("level > 0 AND player_id=?", player.id).
        first

      raise GameLogicError.new(
        "#{player} does not have building repair technology!"
      ) if technology.nil?

      metal, energy, zetium = technology.resources_for_healing(self)
      planet = self.planet
      raise GameLogicError.new(
        "Not enough resources to repair #{self}! M: req:#{metal}/has:#{
          planet.metal}, E: req:#{energy}/has:#{planet.energy}, Z: req:#{
          zetium}/has:#{planet.zetium}"
      ) unless planet.metal >= metal && planet.energy >= energy &&
        planet.zetium >= zetium

      planet.metal -= metal
      planet.energy -= energy
      planet.zetium -= zetium

      self.state = Building::STATE_REPAIRING
      self.cooldown_ends_at = technology.healing_time(damaged_hp).seconds.
        from_now

      save!
      planet.save!

      EventBroker.fire(self, EventBroker::CHANGED)
      EventBroker.fire(planet, EventBroker::CHANGED,
        EventBroker::REASON_OWNER_PROP_CHANGE)
      Objective::RepairHp.progress(player, damaged_hp)
      CallbackManager.register(self, CallbackManager::EVENT_COOLDOWN_EXPIRED,
        cooldown_ends_at)
    end

    # Finish repairs.
    def on_repairs_finished!
      self.hp_percentage = 1
      self.state = Building::STATE_ACTIVE
      self.cooldown_ends_at = nil
      save!
      EventBroker.fire(self, EventBroker::CHANGED)
    end
  end

  module ClassMethods
    def on_callback(id, event)
      if event == CallbackManager::EVENT_COOLDOWN_EXPIRED
        find(id).on_repairs_finished!
      elsif defined?(super)
        super(id, event)
      else
        raise ArgumentError.new("Unknown event #{event} (#{
          CallbackManager::STRING_NAMES[event]}) for #{self} ID #{id}!")
      end
    end
  end
end