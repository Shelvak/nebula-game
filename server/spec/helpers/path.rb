class ZonePath
  attr_reader :points

  def initialize
    @points = []
  end

  def first; @points.first; end
  def last; @points.last; end
  
  def from(x, y)
    @points.push point(x, y)

    self
  end

  alias :to :from

  def through(*args)
    raise "args.size must be even!" unless args.size % 2 == 0

    until args.blank?
      x = args.shift
      y = args.shift
      @points.push point(x, y)
    end

    self
  end

  private
  def point(x, y)
    raise NotImplementedError.new("Please implement me!")
  end
end

class GalaxyPath < ZonePath
  def initialize(galaxy)
    super()
    @id = galaxy.id
  end

  private
  def point(x, y); GalaxyPoint.new(@id, x, y); end
end

class SolarSystemPath < ZonePath
  def initialize(solar_system)
    super()
    @id = solar_system.id
  end

  private
  def point(x, y); SolarSystemPoint.new(@id, x, y); end
end

class PlanetPath < ZonePath
  def initialize(planet)
    super()
    @id = planet.id
    to(nil, nil)
  end

  private
  def point(x, y); LocationPoint.new(@id, Location::SS_OBJECT, x, y); end
end

class Path
  attr_reader :jumpgate, :reverse_jumpgate, :description

  def initialize(description)
    @description = description
    @zone_paths = []
  end

  def via(jumpgate, reverse_jumpgate=nil)
    @jumpgate, @reverse_jumpgate = jumpgate, reverse_jumpgate
    self
  end

  def galaxy(galaxy, &block)
    galaxy_path = GalaxyPath.new(galaxy)
    galaxy_path.instance_eval(&block)
    add_path(galaxy_path)
    self
  end

  def solar_system(solar_system, &block)
    solar_system_path = SolarSystemPath.new(solar_system)
    solar_system_path.instance_eval(&block)
    add_path(solar_system_path)
    self
  end

  def planet(planet)
    add_path(PlanetPath.new(planet))
    self
  end

  def forward; points[1..-1]; end
  def backward; points[0..-2].reverse; end

  def source; resolve(@source); end
  def target; resolve(@target); end

  private
  def resolve(location_point)
    if location_point.type == Location::SS_OBJECT
      location_point.object
    else
      location_point
    end
  end

  def points
    @zone_paths.map { |zone_path| zone_path.points }.flatten
  end

  def add_path(zone_path)
    @source = zone_path.first if @zone_paths.blank?
    @target = zone_path.last
    @zone_paths.push zone_path
  end
end

Spec::Matchers.define :be_path do |points|
  match do |actual|
    @actual_path = actual.map do |point|
      case point['type']
      when Location::GALAXY
        GalaxyPoint.new(point['id'], point['x'], point['y'])
      when Location::SOLAR_SYSTEM
        SolarSystemPoint.new(point['id'], point['x'], point['y'])
      else
        LocationPoint.new(point['id'], point['type'],
          point['x'], point['y'])
      end
    end
    @actual_path == points
  end
  failure_message_for_should do |actual|
    "Paths were not equal!
Expected: #{points.join(" ")}
Actual  : #{@actual_path.join(" ")}"
  end
  failure_message_for_should_not do |player|
    "target and actual paths should have not been equal but they were"
  end
  description do
    "For checking #find_path in SpaceMule"
  end
end
