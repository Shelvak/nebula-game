class Objective::SelfDestruct < Objective
  def self.progress(building); super([building]); end
end