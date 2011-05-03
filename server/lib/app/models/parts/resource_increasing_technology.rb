module Parts
  module ResourceIncreasingTechnology
    def self.included(receiver)
      super(receiver)
      receiver.extend ClassMethods
      receiver.send :include, InstanceMethods
      receiver.send :include, Parts::WithProperties
    end

    module InstanceMethods
      def on_upgrade_finished
        super
        # Find all planets to ensure SsObject::Planet#after_find hits every of
        # them
        SsObject::Planet.where(:player_id => player_id).all
      end

      def resource_modifiers
        self.class.resource_modifiers(level)
      end
    end

    module ClassMethods
      def resource_modifiers(level)
        {
          :metal => metal_generate_mod(level),
          :metal_storage => metal_store_mod(level),
          :energy => energy_generate_mod(level),
          :energy_storage => energy_store_mod(level),
          :zetium => zetium_generate_mod(level),
          :zetium_storage => zetium_store_mod(level),
        }
      end
    end
  end
end
