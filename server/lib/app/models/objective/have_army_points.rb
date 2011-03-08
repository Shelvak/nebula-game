class Objective::HaveArmyPoints < Objective::HavePoints
  def self.points_method; :army_points; end
end