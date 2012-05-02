# Destroy number of objects to fulfill this objective.
class Objective::Destroy < Objective
  def filter(models)
    models = models.accept { |model| model.level >= level } unless level.nil?
    models
  end

  class << self
    # Save killed_by information before progressing.
    def progress(models, options={})
      typesig binding, Array, Hash

      raise ArgumentError,
        "#killed_by was nil, but it should not have been for #{
        models.inspect}!" \
        if models.killed_by.nil?

      super(models, options.merge(:data => models.killed_by))
    end

    # Only killers benefit from destroying objects.
    def count_benefits(objective_models, options)
      counts = {}

      objective_models.each do |model|
        killer_player_id = options[:data][model]
        counts[killer_player_id] = (counts[killer_player_id] || 0) + 1
      end

      counts
    end
  end
end
