class Objective::HaveSciencePoints < Objective::HavePoints
  def self.points_method; :science_points; end
end