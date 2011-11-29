# Module that is included for buildings that manage resources.
#
module Parts::ResourceManager
  OVERDRIVE_OUTPUT_ATTRIBUTES = (Resources::TYPES - [:energy]).
    map { |attr| "#{attr}_generation_rate" }

	def self.included(receiver)
    receiver.extend ClassMethods
    receiver.send(:include, InstanceMethods)
	end

	module ClassMethods
    def manages_resources?
      Resources::TYPES.each do |resource|
        %w{generate use store}.each do |type|
          return true unless property("#{resource}.#{type}").nil?
        end
      end

      false
    end

    # TODO: ditch the stupid .generate/use and replace it with single .rate
    # property.

    Resources::TYPES.each do |resource|
      define_method("#{resource}_generation_rate") do |level|
        raise ArgumentError.new("level must not be nil!") if level.nil?
        evalproperty("#{resource}.generate", 0, 'level' => level).to_f.
          round(ROUNDING_PRECISION)
      end

      define_method("#{resource}_usage_rate") do |level|
        raise ArgumentError.new("level must not be nil!") if level.nil?
        evalproperty("#{resource}.use", 0, 'level' => level).to_f.
          round(ROUNDING_PRECISION)
      end

      define_method("#{resource}_rate") do |level|
        raise ArgumentError.new("level must not be nil!") if level.nil?
        send("#{resource}_generation_rate", level) -
          send("#{resource}_usage_rate", level)
      end

      define_method("#{resource}_storage") do |level|
        raise ArgumentError.new("level must not be nil!") if level.nil?
        evalproperty("#{resource}.store", 0, 'level' => level).to_f.
          round(ROUNDING_PRECISION)
      end
    end

    # Only include this module if subclass actually manages resources.
    def inherited(subclass)
      super(subclass)
      
      subclass.send(:include, InstanceCallbacks) \
        if subclass.manages_resources?
    end
	end

	module InstanceMethods
    Resources::TYPES.each do |resource|
      [
        "#{resource}_generation_rate", "#{resource}_usage_rate",
        "#{resource}_storage"
      ].each do |method|
        define_method(method) do |*args|
          value = self.class.send(method, args[0] || level)

          # Account for energy mod
          if method == "energy_generation_rate"
            calculate_mods if energy_mod.nil?
            value = (value * (100.0 + energy_mod) / 100).to_f.
              round(ROUNDING_PRECISION)
          end

          # Overdrive support.
          if overdriven?
            if method == "energy_usage_rate"
              value *= Cfg.buildings_overdrive_energy_usage_multiplier
            elsif Parts::ResourceManager::OVERDRIVE_OUTPUT_ATTRIBUTES.
                include?(method)
              value *= Cfg.buildings_overdrive_output_multiplier
            end
          end
          
          value
        end
      end

      define_method("#{resource}_rate") do |*args|
        send("#{resource}_generation_rate", args[0] || level) -
          send("#{resource}_usage_rate", args[0] || level)
      end
    end
	end

  module InstanceCallbacks
    def on_upgrade_finished
      super if defined?(super)
      planet.increase!(
        :metal_storage => metal_storage - metal_storage(level - 1),
        :energy_storage => energy_storage - energy_storage(level - 1),
        :zetium_storage => zetium_storage - zetium_storage(level - 1)
      )
    end

    def on_activation
      super if defined?(super)
      planet.increase!(
        :metal_generation_rate => metal_generation_rate,
        :metal_usage_rate => metal_usage_rate,
        :energy_generation_rate => energy_generation_rate,
        :energy_usage_rate => energy_usage_rate,
        :zetium_generation_rate => zetium_generation_rate,
        :zetium_usage_rate => zetium_usage_rate
      )
    end

    def on_deactivation
      super if defined?(super)
      planet.increase!(
        :metal_generation_rate => -metal_generation_rate,
        :metal_usage_rate => -metal_usage_rate,
        :energy_generation_rate => -energy_generation_rate,
        :energy_usage_rate => -energy_usage_rate,
        :zetium_generation_rate => -zetium_generation_rate,
        :zetium_usage_rate => -zetium_usage_rate
      )
    end

    def on_destroy
      super if defined?(super)
      planet.increase!(
        :metal_storage => -metal_storage,
        :energy_storage => -energy_storage,
        :zetium_storage => -zetium_storage
      )
    end
  end
end