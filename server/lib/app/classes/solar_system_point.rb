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

    num_of_quarter_points = position + 1
    quarter_point_degrees = 90 / num_of_quarter_points
    (angle % 90) % quarter_point_degrees == 0
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

  # See Location#client_location
  def client_location
    ClientLocation.new(@id, Location::SOLAR_SYSTEM, position, angle,
      nil, solar_system.kind, nil, nil)
  end
end
