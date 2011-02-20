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

      def on_upgrade_just_finished_before_save
        super
        # TODO: drop hp_remainder and progressive hp and just add diff
        # between levels.
        self.hp = hit_points
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
