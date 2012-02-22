module Parts::WithCallbackableCooldown
  def self.included(receiver)
    receiver.send :include, Parts::WithCooldown
    receiver.send :include, InstanceMethods
  end

  module InstanceMethods
    def cooldown_expired!
      raise NotImplementedError.new(
        "Cooldown has expired and I have no idea what to do!"
      )
    end
  end
end
