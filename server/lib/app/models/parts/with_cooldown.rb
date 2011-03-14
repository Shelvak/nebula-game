module Parts::WithCooldown
  def self.included(receiver)
    receiver.send :include, InstanceMethods
    receiver.extend ClassMethods
  end

  module InstanceMethods
    # When the next cooldown should end.
    def cooldowns_at; evalproperty('cooldown').seconds.from_now; end

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
    def on_callback(id, event)
      if event == CallbackManager::EVENT_COOLDOWN_EXPIRED
        find(id).cooldown_expired!
      else
        super(id, event)
      end
    end
  end
end
