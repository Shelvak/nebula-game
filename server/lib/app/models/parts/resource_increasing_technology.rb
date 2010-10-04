module Parts
  module ResourceIncreasingTechnology
    def self.included(receiver)
      super(receiver)
      receiver.extend ClassMethods
      receiver.send :include, InstanceMethods
      receiver.send :include, Parts::WithProperties
      ResourcesEntry.add_modifier(receiver.to_s.demodulize)
    end

    module InstanceMethods
      def on_upgrade_finished
        super
        # Find all planets to ensure ResourcesEntry#after_find hits every of
        # them
        ResourcesEntry.joins(:planet).where(
          :planets => {:player_id => player_id}
        ).all
      end

      def resource_modifiers
        self.class.resource_modifiers(level)
      end
    end

    module ClassMethods
      def resource_modifiers(level)
        {
          :metal => evalproperty("mod.metal.generate", 0, 'level' => level),
          :metal_storage => evalproperty("mod.metal.store", 0,
            'level' => level),
          :energy => evalproperty("mod.energy.generate", 0,
            'level' => level),
          :energy_storage => evalproperty("mod.energy.store", 0,
            'level' => level),
          :zetium => evalproperty("mod.zetium.generate", 0,
            'level' => level),
          :zetium_storage => evalproperty("mod.zetium.store", 0,
            'level' => level),
        }
      end
    end
  end
end
