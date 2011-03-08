class Objective::HaveWarPoints < Objective::HavePoints
  def self.points_method; :war_points; end
end