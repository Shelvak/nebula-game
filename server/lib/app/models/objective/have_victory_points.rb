class Objective::HaveVictoryPoints < Objective::HavePoints
  def self.points_method; :victory_points; end
end
