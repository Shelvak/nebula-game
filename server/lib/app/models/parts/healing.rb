module Parts::Healing
  def self.included(receiver)
    receiver.send :include, InstanceMethods
    receiver.extend ClassMethods
  end

  module InstanceMethods
    # Returns [metal, energy, zetium] needed to heal _unit_.
    def resources_for_healing(object)
      percentage_to_heal = object.damaged_percentage
      mod = cost_modifier
      metal = (object.metal_cost * percentage_to_heal * mod).round
      energy = (object.energy_cost * percentage_to_heal * mod).round
      zetium = (object.zetium_cost * percentage_to_heal * mod).round

      [metal, energy, zetium]
    end

    def cost_modifier(level=nil)
      self.class.cost_modifier(level || self.level)
    end

    def healing_time(hp, level=nil)
      self.class.healing_time(hp, level || self.level)
    end
  end

  module ClassMethods
    def cost_modifier(level)
      evalproperty('healing.cost.mod', nil, 'level' => level)
    end

    def healing_time(hp, level)
      (hp * evalproperty('healing.time.mod', nil, 'level' => level)).ceil
    end
  end
end