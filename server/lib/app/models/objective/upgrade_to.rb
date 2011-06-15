# Upgrade number of objects to fulfill this objective.
class Objective::UpgradeTo < Objective
  def filter(models, strict)
    models.accept do |model|
      strict ? model.level == level : model.level >= level
    end
  end

  # Progress models. If strict is true, then filter levels using ==, otherwise
  # use >=.
  def self.progress(models, strict=true)
    @strict_mode = strict
    super(models)
    @strict_mode = true
  end

  # Same as #progress.
  def self.regress(models, strict=true)
    @strict_mode = strict
    ret = super(models)
    @strict_mode = true
    
    ret
  end

  def self.filter(objective, class_models)
    objective.filter(class_models, @strict_mode)
  end
end
