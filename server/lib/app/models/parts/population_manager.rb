module Parts::PopulationManager
  # Regexp used to match building guns in config.
  POPULATION_REGEXP = /^buildings\.(.+?)\.population$/

  def self.included(receiver)
    receiver.extend ClassMethods
    receiver.send(:include, InstanceMethods)
  end

  module ClassMethods
    # Does this class manages max population?
    def manages_population?; ! property('population').nil?; end

    # Return Array of building types (camelcased strings) that give population.
    def population_types(clear_cache=false)
      @@types = nil if clear_cache
      return @@types if defined?(@@types)

      types = []
      CONFIG.each_matching(POPULATION_REGEXP) do |key, population|
        type = key.match(POPULATION_REGEXP)[1].camelcase
        types << type
      end

      @@types = types
    end

    # How much population does this class give at _level_?
    def population(level)
      evalproperty("population", 0, 'level' => level)
    end
  end

  module InstanceMethods
    # How much population does this class give?
    def population(level=nil)
      self.class.population(level || self.level)
    end

    def on_activation
      super if defined?(super)
      # Player can be nil if this unit has constructed in NPC planet.
      player.recalculate_population! \
        if self.class.manages_population? && ! player.nil?
    end

    def on_deactivation
      super if defined?(super)
      # Player can be nil if this unit has constructed in NPC planet.
      player.recalculate_population! \
        if self.class.manages_population? && ! player.nil?
    end
  end
end
