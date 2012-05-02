class Objective::MoveBuilding < Objective
  # Progress for this player.
  def self.progress(building, *args); super([building], *args); end
end