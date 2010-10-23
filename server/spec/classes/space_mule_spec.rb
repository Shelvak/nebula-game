require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

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

def from(x, y)
  Path.new(x, y)
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

describe SpaceMule do
  before(:all) do
    @mule = SpaceMule.instance
  end

  describe "#new_player" do
    it "should create homeworld for player" do
      player = Factory.create(:player)
      @mule.new_player(player.galaxy_id, [player.id])
      Planet::Homeworld.where(:player_id => player.id).first.should_not \
        be_nil
    end
  end

  describe "#find_path" do
    describe "galaxy" do
      [
        # Straight lines
        from(0,0).through(1,0, 2,0).to(3,0).desc("right"),
        from(0,0).through(-1,0, -2,0).to(-3,0).desc("left"),
        from(0,0).through(0,1, 0,2).to(0,3).desc("top"),
        from(0,0).through(0,-1, 0,-2).to(0,-3).desc("bottom"),
        # Diagonal lines
        from(0,0).through(1,1, 2,2).to(3,3).desc("top-right"),
        from(0,0).through(-1,-1, -2,-2).to(-3,-3).desc("bottom-left"),
        from(0,0).through(-1,1, -2,2).to(-3,3).desc("top-left"),
        from(0,0).through(1,-1, 2,-2).to(3,-3).desc("bottom-right"),
        # Bent lines
        from(0,0).through(1,1, 2,2, 3,2).to(4,2).desc("top-right right"),
        from(0,0).through(1,1, 2,2, 2,3).to(2,4).desc("top-right up"),
        from(0,0).through(-1,0, -2,0, -3,-1).to(-4,-2).desc(
          "bottom-left left"),
        from(0,0).through(0,-1, 0,-2, -1,-3).to(-2,-4).desc(
          "bottom-left down"),
        from(0,0).through(-1,0, -2,0, -3,1).to(-4,2).desc(
          "top-left left"),
        from(0,0).through(0,1, 0,2, -1,3).to(-2,4).desc(
          "top-left up"),
        from(0,0).through(1,-1, 2,-2, 3, -2).to(4,-2).desc(
          "bottom-right right"),
        from(0,0).through(1,-1, 2,-2, 2,-3).to(2,-4).desc(
          "bottom-right down"),
      ].each do |path|
        it "should find #{path.description}" do
          @mule.find_path(
            path.source.galaxy_point,
            path.target.galaxy_point
          ).should be_path(path.forward)
        end

        it "should go in same path if reversed for #{path.description}" do
          @mule.find_path(
            path.target.galaxy_point,
            path.source.galaxy_point
          ).should be_path(path.backward)
        end
      end
    end

    describe "solar system" do
      before(:all) do
        @ss = Factory.create(:solar_system)
      end

      [
        from(0,0).through(1,0, 2,0).to(3,0).desc("straight line"),
        from(0,0).through(0,90).to(0,180).desc("other side of circle"),
        from(1,0).through(0,0, 0,90, 0,180).to(1,180).desc(
          "other side of circle 2"),
        from(1,0).through(1,45).to(1,90).desc("perpendicular ccw"),
        from(1,0).through(1,315).to(1,270).desc("perpendicular cw"),
      ].each do |path|
        it "should find #{path.description}" do
          @mule.find_path(
            path.source.solar_system_point(@ss.id),
            path.target.solar_system_point(@ss.id)
          ).should be_path(path.forward)
        end

        it "should go in same path if reversed for #{path.description}" do
          @mule.find_path(
            path.target.solar_system_point(@ss.id),
            path.source.solar_system_point(@ss.id)
          ).should be_path(path.backward)
        end
      end
    end

#    describe "all variations" do
#      @galaxy = Factory.create :galaxy
#      @gp1 = GalaxyPoint.new(@galaxy.id, 4, -2)
#      @gp2 = GalaxyPoint.new(@galaxy.id, -3, 6)
#      @ss1 = Factory.create :solar_system, :galaxy => @galaxy
#      @sp1 = SolarSystemPoint.new(@ss1.id, 3, 270 + 22)
#      @ss2 = Factory.create :solar_system, :galaxy => @galaxy,
#        :x => 5, :y => 5
#      @sp2 = SolarSystemPoint.new(@ss2.id, 2, 180 + 60)
#      @p1 = Factory.create :planet, :solar_system => @ss1
#      @jg1 = Factory.create :p_jumpgate, :solar_system => @ss1,
#        :position => 3, :angle => 90 + 22 * 3
#      @p2 = Factory.create :planet, :solar_system => @ss2
#      @jg2 = Factory.create :p_jumpgate, :solar_system => @ss2,
#        :position => 3, :angle => 180 + 22
#
#      it "should raise GameLogicError if JG is not in same SS as source" do
#        lambda do
#          @mule.find_path(@p1, @p2, @jg2)
#        end.should raise_error(GameLogicError)
#      end
#
#      # Through JG ant not
#      [
#        [nil, "no JG"],
#        [@jg1, "via JG"]
#      ].each do |jumpgate, jgdesc|
#        [
#          ["Planet->Planet", @p1, @p2],
#          ["Planet->Solar system point (same ss)", @p1, @sp1],
#          ["Planet->Solar system point", @p1, @sp2],
#          ["Planet->Galaxy point", @p1, @gp1],
#          ["Solar system point->Planet", @sp1, @p2],
#          ["Solar system point->Solar system point", @sp1, @sp2],
#          ["Solar system point->Galaxy point", @sp1, @gp1],
#          ["Galaxy point->Planet", @gp1, @p2],
#          ["Galaxy point->Solar system point", @gp1, @sp2],
#          ["Galaxy point->Galaxy point", @gp1, @gp2],
#        ].each do |description, location1, location2|
#          it "should find path for #{description} (#{jgdesc})" do
#            path = @mule.find_path(location1, location2, jumpgate)
#            path.should be_instance_of(Array)
#            path.should_not be_blank
#          end
#        end
#      end
#    end
  end
end