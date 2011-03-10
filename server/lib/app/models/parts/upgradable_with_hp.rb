module Parts
  module UpgradableWithHp
    def self.included(receiver)
      receiver.send(:include, Parts::Upgradable)
      receiver.send(:include, InstanceMethods)
      receiver.send(:validate, :validate_hp)
      receiver.extend ClassMethods
    end

    module ClassMethods
      def hit_points(level)
        (level || 0) == 0 ? 0 : evalproperty('hp', 0, 'level' => level)
      end
    end

    module InstanceMethods
      def on_upgrade_just_finished_before_save
        super
        self.hp += hit_points(level) - hit_points(level - 1)
      end

      def dead?; hp <= 0; end
      def alive?; not dead?; end

      def validate_hp
        hp = self.hp || 0
        hp_max = self.hp_max
        errors.add(:hp, "#{hp} is more than maximum #{hp_max} for #{
          self.inspect}!") if hp > hp_max
      end

      # Maximum number of HP item can have.
      def hp_max
        hit_points(upgrading? ? level + 1 : level)
      end
      
      def hit_points(level=nil)
        self.class.hit_points(level || self.level)
      end
    end
  end
end
