module Parts::WithCooldown
  def self.included(receiver)
    raise ArgumentError.new(
      "You cannot mix #{self} with Parts::Repairable because they both " +
        "use #cooldown_ends_at!"
    ) if receiver.include?(Parts::Repairable)

    receiver.send :include, InstanceMethods
    receiver.extend ClassMethods
  end

  module InstanceMethods
    # When the next cooldown should end.
    def cooldowns_at
      time_owned = planet.owner_changed.nil? \
        ? 0 : (Time.now - planet.owner_changed).to_i
      self.class.cooldowns_at(level, time_owned)
    end

    # Checks if the cooldown has expired.
    def cooldown_expired?
      (cooldown_ends_at.nil? || cooldown_ends_at <= Time.now)
    end

    def cooldown_expired!
      raise NotImplementedError.new(
        "Cooldown has expired and I have no idea what to do!")
    end
  end

  module ClassMethods
    # When the next cooldown should end.
    def cooldowns_at(level, time_owned)
      evalproperty('cooldown', nil, 
        'level' => level, 'time_owned' => time_owned).seconds.from_now
    end
    
    def on_callback(id, event)
      if event == CallbackManager::EVENT_COOLDOWN_EXPIRED
        find(id).cooldown_expired!
      else
        super(id, event)
      end
    end
  end
end
