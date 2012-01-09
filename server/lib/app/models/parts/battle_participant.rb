# Include me in classes that participate in battle.
module Parts::BattleParticipant
  def self.included(receiver)
    receiver.extend ClassMethods
    receiver.send :include, InstanceMethods
    # All battle participants probably are shooting.
    receiver.send :include, Parts::Shooting
  end

  module InstanceMethods
    def ground?; self.class.ground?; end
    def space?; self.class.space?; end
    def can_fight?; self.class.can_fight?; end

    def dead?; hp <= 0; end
    def alive?; not dead?; end
    def stance_valid?; self.class.stance_valid?(stance); end

    def stance_property(name)
      self.class.stance_property(stance, name)
    end

    def armor_mod; self.class.armor_mod(level); end
  end

  module ClassMethods
    def ground?; property('kind') == :ground; end
    def space?; property('kind') == :space; end
    def can_fight?; ! property('guns', []).blank? || space? ; end

    # Return armor mod for _level_.
    def armor_mod(level)
      evalproperty('armor_mod', 0, 'level' => level)
    end

    def stance_valid?(stance)
      stance == Combat::STANCE_NEUTRAL ||
        stance == Combat::STANCE_DEFENSIVE ||
        stance == Combat::STANCE_AGGRESSIVE
    end
    
    # Returns property of stance or default of 1.0 if property is not
    # defined.
    def stance_property(stance, name)
      CONFIG["combat.stance.#{stance}.#{name}"] || 1.0
    end
  end
end