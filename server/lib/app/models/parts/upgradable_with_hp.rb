module Parts
  module UpgradableWithHp
    def self.included(receiver)
      receiver.send(:include, Parts::Upgradable)
      receiver.send(:include, InstanceMethods)
      receiver.send(:validate, :validate_hp)
      receiver.extend ClassMethods
    end

    module ClassMethods
      def hit_points; property('hp'); end
    end

    module InstanceMethods
      def dead?; hp_percentage <= 0; end
      def alive?; not dead?; end
      
      def hp; (hp_percentage * hit_points).round; end
      def hp=(value)
        self.hp_percentage = value.to_f / hit_points
      end

      def validate_hp
        errors.add(:hp, "#{hp_percentage} is more than 1 (100%) for #{
          self.inspect}!") if hp_percentage > 1
      end

      def hit_points; self.class.hit_points; end

      def damaged_hp
        hit_points - hp
      end

      # Returns floating point percentage of how much object HP is gone.
      def damaged_percentage
        1 - alive_percentage
      end

      # Returns floating point percentage of how much object HP is intact.
      def alive_percentage
        hp.to_f / hit_points
      end
    end
  end
end
