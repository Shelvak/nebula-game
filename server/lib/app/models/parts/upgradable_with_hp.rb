module Parts
  module UpgradableWithHp
    def self.included(receiver)
      receiver.send(:include, Parts::Upgradable)
      receiver.send(:include, InstanceMethods)
      receiver.extend ClassMethods
    end

    module ClassMethods
      def hit_points(level)
        level == 0 ? 0 : evalproperty('hp', 0, 'level' => level)
      end
    end

    module InstanceMethods
      def update_upgrade_properties!
        super do |now, time_diff|
          hp_diff = hit_points(level + 1) - hit_points
          nominator = time_diff * hp_diff
          denominator = upgrade_time(level + 1)

          self.hp += nominator / denominator
          self.hp_remainder += nominator % denominator

          if hp_remainder >= denominator
            self.hp += hp_remainder / denominator
            self.hp_remainder = hp_remainder % denominator
          end
        end
      end

      def dead?; hp <= 0; end
      def alive?; not dead?; end

      # HP writer that doesn't allow setting more than max HP.
      def hp=(value)
        write_attribute(:hp, value > hp_max ? hp_max : value)
      end

      # Maximum number of HP item can have.
      def hp_max
        hit_points(upgrading? ? level + 1 : level)
      end

    end
  end
end
