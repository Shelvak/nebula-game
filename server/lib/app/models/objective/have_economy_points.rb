class Objective::HaveEconomyPoints < Objective::HavePoints
  def self.points_method; :economy_points; end
end