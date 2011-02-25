# Including this module will ensure that when callback is finished player
# that controls the planet this building is on will get units defined in
# #bonus method.
module Parts::UnitBonus
  def self.included(receiver)
    receiver.send(:include, InstanceMethods)
    receiver.extend(ClassMethods)
  end
  
  # These methods will be included in instances.
  module InstanceMethods
    def unit_bonus; self.class.unit_bonus; end

    # Gives units when cooldown expires.
    def cooldown_expired!
      super
      Unit.give_units(unit_bonus, planet, planet.player) if planet.player
    end
  end
  
  # These methods will be included in class.
  module ClassMethods
    # Description of bonus units which will be given to player.
    def unit_bonus; property('unit_bonus'); end
  end
end
