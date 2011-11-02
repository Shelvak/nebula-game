# Class to identify one particular point in solar system.
class SolarSystemPoint < LocationPoint
  def initialize(id, position, angle)
    raise ArgumentError.new(
      "position must be >= 0, but #{position} was given."
    ) unless position >= 0
    raise ArgumentError.new(
      "angle must be valid for position #{position}, but invalid angle #{
        angle} was given."
    ) unless self.class.angle_valid?(position, angle)

    super(id, Location::SOLAR_SYSTEM, position, angle)
  end

  # Angle validity is calculated like this:
  # 1. There are position (starts from 0) + 1 quarter points. Quarter point
  # is a point, where 0 <= angle < 90.
  # 2. Angle must be a quarter point to be valid.
  #
  def self.angle_valid?(position, angle)
    return false unless (0...360).include?(angle)

    num_of_quarter_points = num_of_quarter_points(position)
    quarter_point_degrees = quarter_point_degrees(num_of_quarter_points)
    (angle % 90) % quarter_point_degrees == 0
  end

  # Returns all possible solar system points for solar system with _id_.
  def self.all_orbit_points(id)
    points = Set.new
    0.upto(Cfg.solar_system_orbit_count) do |position|
      points = points | orbit_points(id, position)
    end

    points
  end

  # Returns all possible solar system points for its one orbit with _position_.
  def self.orbit_points(id, position)
    points = Set.new
    num_of_quarter_points = num_of_quarter_points(position)
    quarter_point_degrees = quarter_point_degrees(num_of_quarter_points)

    0.upto(3) do |quarter|
      0.upto(num_of_quarter_points - 1) do |qp_index|
        points.add new(
          id, position, quarter * 90 + qp_index * quarter_point_degrees
        )
      end
    end

    points
  end

  def self.num_of_quarter_points(position)
    position + 1
  end

  def self.quarter_point_degrees(num_of_quarter_points)
    90 / num_of_quarter_points
  end

  alias :position :x
  alias :angle :y

  def galaxy_id; solar_system.galaxy_id; end
  def galaxy; solar_system.galaxy; end
  # Returns solar system in which this point is.
  def solar_system; SolarSystem.find(@id); end
  def solar_system_id; @id; end
  def zone; SolarSystem.find(@id); end

  def to_s
    "<SP(#{@id}):#{position},#{angle}>"
  end
end
