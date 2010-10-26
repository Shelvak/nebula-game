# Module that is included for buildings that manage resources.
#
module Parts::ResourceManager
	def self.included(receiver)
    receiver.extend ClassMethods
    receiver.send(:include, InstanceMethods)
	end

	module ClassMethods
    def manages_resources?
      %w{metal energy zetium}.each do |resource|
        %w{generate use store}.each do |type|
          return true unless property("#{resource}.#{type}").nil?
        end
      end

      false
    end

    # Only include this module if subclass actually manages resources.
    def inherited(subclass)
      super(subclass)
      
      subclass.send(:include, InstanceCallbacks) \
        if subclass.manages_resources?
    end
	end

	module InstanceMethods
    %w{metal energy zetium}.each do |resource|
      define_method("#{resource}_generation_rate") do |*args|
        for_level = args[0] || level

        value = evalproperty("#{resource}.generate", 0,
          'level' => for_level) * CONFIG['speed']

        # Account for energy mod
        resource == "energy" \
          ? (value * (100.0 + energy_mod) / 100) \
          : value
      end

      define_method("#{resource}_usage_rate") do |*args|
        for_level = args[0] || level
        evalproperty("#{resource}.use", 0, 'level' => for_level) * \
          CONFIG['speed']
      end

      define_method("#{resource}_rate") do |*args|
        send("#{resource}_generation_rate", *args) -
          send("#{resource}_usage_rate", *args)
      end

      define_method("#{resource}_storage") do |*args|
        for_level = args[0] || level
        evalproperty("#{resource}.store", 0, 'level' => for_level)
      end
    end
	end

  module InstanceCallbacks
    def on_upgrade_finished
      super
      ResourcesEntry.increase(planet_id,
        :metal_storage => metal_storage - metal_storage(level - 1),
        :energy_storage => energy_storage - energy_storage(level - 1),
        :zetium_storage => zetium_storage - zetium_storage(level - 1)
      )
    end

    def on_activation
      super
      ResourcesEntry.increase(planet_id,
        :metal_rate => metal_rate,
        :energy_rate => energy_rate,
        :zetium_rate => zetium_rate
      )
    end

    def on_deactivation
      super
      ResourcesEntry.increase(planet_id,
        :metal_rate => -metal_rate,
        :energy_rate => -energy_rate,
        :zetium_rate => -zetium_rate
      )
    end

    def on_destroy
      super if defined?(super)
      ResourcesEntry.increase(planet_id,
        :metal_storage => -metal_storage,
        :energy_storage => -energy_storage,
        :zetium_storage => -zetium_storage
      )
    end
  end
end