class Objective::MoveBuilding < Objective
  # Progress for this player.
  def self.progress(building); super([building]); end
end