class Objective::SelfDestruct < Objective
  def self.progress(building, *args); super([building], *args); end
end