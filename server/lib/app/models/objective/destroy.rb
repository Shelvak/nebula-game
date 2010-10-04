# Destroy number of objects to fulfill this objective.
class Objective::Destroy < Objective
  class << self
    # Save killed_by information before progressing.
    def progress(models)
      @killed_by = models.killed_by
      super(models)
    end

    # Only killers benefit from destroying objects.
    def count_benefits(objective_models)
      counts = {}

      objective_models.each do |model|
        killer_player_id = @killed_by[model]
        counts[killer_player_id] = (counts[killer_player_id] || 0) + 1
      end

      counts
    end
  end
end