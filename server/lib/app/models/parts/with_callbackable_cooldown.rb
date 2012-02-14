module Parts::WithCallbackableCooldown
  def self.included(receiver)
    raise "I can only be included in Building, not #{receiver}!" \
      unless receiver < Building # Check for inheritance

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
    def cooldown_expired_scope(building); DScope.planet(building.planet); end
    def cooldown_expired_callback(building); building.cooldown_expired!; end
  end
end
