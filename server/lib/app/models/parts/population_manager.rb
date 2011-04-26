module Parts::PopulationManager
  def self.included(receiver)
    receiver.extend ClassMethods
    receiver.send(:include, InstanceMethods)
  end

  module ClassMethods
    # Does this class manages max population?
    def manages_population?; ! property('population').nil?; end

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

    def on_upgrade_finished
      super if defined?(super)
      population_change = population - population(level - 1)
      if population_change != 0
        player = self.player
        player.population_max += population_change
        player.save!
      end
    end

    def on_destroy
      super if defined?(super)
      population_change = population
      if population_change != 0
        player = self.player
        player.population_max -= population_change
        player.save!
      end
    end
  end
end
