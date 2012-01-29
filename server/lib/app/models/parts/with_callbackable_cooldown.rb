module Parts::WithCallbackableCooldown
  def self.included(receiver)
    receiver.send :include, Parts::WithCooldown
    receiver.send :include, InstanceMethods
    receiver.extend ClassMethods
  end

  module InstanceMethods
    def cooldown_expired!
      raise NotImplementedError.new(
        "Cooldown has expired and I have no idea what to do!"
      )
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
