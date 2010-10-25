
class PathPoint
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  def galaxy_point(id=1)
    GalaxyPoint.new(id, @x, @y)
  end

  def solar_system_point(id=1)
    SolarSystemPoint.new(id, @x, @y)
  end

  def ==(other)
    other.is_a?(self.class) && other.x == @x && other.y == @y
  end

  def to_s
    "(#{@x},#{@y})"
  end
end

class Path
  attr_reader :source, :target, :description

  def initialize(from_x, from_y)
    @source = PathPoint.new(from_x, from_y)
    @points = []
  end

  def to(x, y)
    @target = PathPoint.new(x, y)

    self
  end

  def through(*args)
    raise "args.size must be even!" unless args.size % 2 == 0

    @points = []
    until args.blank?
      x = args.shift
      y = args.shift
      @points.push PathPoint.new(x, y)
    end

    self
  end

  def desc(value)
    @description = value

    self
  end

  def forward
    @points + [@target]
  end

  def backward
    @points.reverse + [@source]
  end
end


Spec::Matchers.define :be_path do |points|
  match do |actual|
    @actual_path = actual.map do |point|
      PathPoint.new(point['x'], point['y'])
    end
    @actual_path == points
  end
  failure_message_for_should do |actual|
    "Paths were not equal!
Expected: #{points}
Actual  : #{@actual_path}"
  end
  failure_message_for_should_not do |player|
    "target and actual paths should have not been equal but they were"
  end
  description do
    "For checking #find_path in SpaceMule"
  end
end
