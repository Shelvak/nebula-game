# Upgrade number of objects to fulfill this objective.
class Objective::UpgradeTo < Objective
  # If strict is true, then filter levels using ==, otherwise use >=.
  def filter(models, strict)
    models.accept do |model|
      strict ? model.level == level : model.level >= level
    end
  end

  class << self
    def filter(objective, class_models, options)
      objective.filter(class_models, options[:strict])
    end
  end
end
