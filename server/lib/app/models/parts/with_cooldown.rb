module Parts::WithCooldown
  def self.included(receiver)
    raise ArgumentError.new(
      "You cannot mix #{self} with Parts::Repairable because they both " +
        "use #cooldown_ends_at!"
    ) if receiver.include?(Parts::Repairable)

    receiver.send :include, InstanceMethods
    #receiver.extend ClassMethods
  end

  module InstanceMethods
    # Checks if the cooldown has expired.
    def cooldown_expired?
      (cooldown_ends_at.nil? || cooldown_ends_at <= Time.now)
    end

    def as_json(options=nil)
      super(options).merge(:cooldown_ends_at => cooldown_ends_at)
    end
  end

  #module ClassMethods
  #end
end
