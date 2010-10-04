require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe SpaceMule do
  before(:all) do
    @mule = SpaceMule.instance
  end

  describe "#find_path" do
    @galaxy = Factory.create :galaxy
    @gp1 = GalaxyPoint.new(@galaxy.id, 4, -2)
    @gp2 = GalaxyPoint.new(@galaxy.id, -3, 6)
    @ss1 = Factory.create :solar_system, :galaxy => @galaxy
    @sp1 = SolarSystemPoint.new(@ss1.id, 3, 270 + 22)
    @ss2 = Factory.create :solar_system, :galaxy => @galaxy,
      :x => 5, :y => 5
    @sp2 = SolarSystemPoint.new(@ss2.id, 2, 180 + 60)
    @p1 = Factory.create :planet, :solar_system => @ss1
    @jg1 = Factory.create :p_jumpgate, :solar_system => @ss1,
      :position => 3, :angle => 90 + 22 * 3
    @p2 = Factory.create :planet, :solar_system => @ss2
    @jg2 = Factory.create :p_jumpgate, :solar_system => @ss2,
      :position => 3, :angle => 180 + 22

    it "should raise GameLogicError if JG is not in same SS as source" do
      lambda do
        @mule.find_path(
          Factory.create(:planet),
          Factory.create(:planet),
          Factory.create(:p_jumpgate)
        )
      end.should raise_error(GameLogicError)
    end

    # Through JG ant not
    [
      [nil, "no JG"],
      [@jg1, "via JG"]
    ].each do |jumpgate, jgdesc|
      [
        ["Planet->Planet", @p1, @p2],
        ["Planet->Solar system point (same ss)", @p1, @sp1],
        ["Planet->Solar system point", @p1, @sp2],
        ["Planet->Galaxy point", @p1, @gp1],
        ["Solar system point->Planet", @sp1, @p2],
        ["Solar system point->Solar system point", @sp1, @sp2],
        ["Solar system point->Galaxy point", @sp1, @gp1],
        ["Galaxy point->Planet", @gp1, @p2],
        ["Galaxy point->Solar system point", @gp1, @sp2],
        ["Galaxy point->Galaxy point", @gp1, @gp2],
      ].each do |description, location1, location2|
        it "should find path for #{description} (#{jgdesc})" do
          path = @mule.find_path(location1, location2, jumpgate)
          path.should be_instance_of(Array)
          path.should_not be_blank
        end
      end
    end
  end
end