require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Galaxy::Zone do
  describe "#ranges" do
    plus1 = 0..7
    plus2 = 8..15
    minus1 = -8..-1
    minus2 = -16..-9

    [
      [1, 1, plus1, minus1],
      [1, 2, plus2, minus1],
      [1, 3, plus1, minus2],
      [2, 1, minus1, minus1],
      [2, 2, minus2, minus1],
      [2, 3, minus1, minus2],
      [3, 1, minus1, plus1],
      [3, 2, minus2, plus1],
      [3, 3, minus1, plus2],
      [4, 1, plus1, plus1],
      [4, 2, plus2, plus1],
      [4, 3, plus1, plus2],
    ].each do |quarter, slot, x_range, y_range|
      it "should resolve slot #{slot}, quarter #{quarter} range" do
        Galaxy::Zone.new(slot, quarter).ranges.should == [x_range, y_range]
      end
    end
  end

  describe "#free_spot_coords" do
    let(:galaxy) { Factory.create(:galaxy) }
    let(:zone) { Galaxy::Zone.new(5, 3) }

    def fill_zone
      solar_systems = []
      zone.each_coord do |x, y|
        solar_systems << Factory.
          build(:solar_system, :galaxy => galaxy, :x => x, :y => y)
      end
      solar_systems
    end

    it "should return a coordinate pair that fits into that zone" do
      x, y = zone.free_spot_coords(galaxy.id)
      zone.should == Galaxy::Zone.lookup_by_coords(x, y)
    end

    it "should find a free spot even if only one spot exists" do
      solar_systems = fill_zone()
      solar_system = solar_systems.pop
      BulkSql.save(solar_systems, ::SolarSystem)
      zone.free_spot_coords(galaxy.id).should == [
        solar_system.x, solar_system.y
      ]
    end

    it "should raise error if all spots are taken" do
      solar_systems = fill_zone()
      BulkSql.save(solar_systems, ::SolarSystem)
      lambda do
        zone.free_spot_coords(galaxy.id)
      end.should raise_error(RuntimeError)
    end
  end

  describe ".lookup" do
    [
      [0..4, -5..-1],
      [-5..-1, -5..-1],
      [-5..-1, 0..4],
      [0..4, 0..4],
    ].each do |x_range, y_range|
      x_range.each do |x|
        y_range.each do |y|
          it "should look up zone correctly for (#{x},#{y})" do
            looked_up = Galaxy::Zone.lookup(x, y)
            [looked_up.x, looked_up.y].should == [x, y]
          end
        end
      end
    end
  end

  describe ".lookup_by_coords" do
    1.upto(4) do |quarter|
      [1, 2, 3].each do |slot|
        it "should lookup all #{quarter},#{slot} coords to correct zone" do
          zone = Galaxy::Zone.new(slot, quarter)
          zone.each_coord do |x, y|
            Galaxy::Zone.lookup_by_coords(x, y).should == zone
          end
        end
      end
    end
  end

  describe ".relative_coords" do
    diam = Cfg.galaxy_zone_diameter
    [
      [0, 0, 0, 0],
      [-1, 0, diam - 1, 0],
      [-1, -1, diam - 1, diam - 1],
      [0, -1, 0, diam - 1],
      [0, diam, 0, 0],
      [-1, diam, diam - 1, 0],
      [-1, -diam - 1, diam - 1, diam - 1],
      [0, -diam - 1, 0, diam - 1]
    ].each do |x, y, rel_x, rel_y|
      it "should resolve #{x},#{y} -> #{rel_x},#{rel_y}" do
        Galaxy::Zone.relative_coords(x, y).should == [rel_x, rel_y]
      end
    end
  end

  describe ".for_reattachment" do
    let(:galaxy) { Factory.create(:galaxy) }
    let(:player_points) { 1000 }
    let(:ss) do
      lambda do |x, y, eco|
        Factory.create(
          :solar_system, galaxy: galaxy, x: x, y: y, player: player[eco]
        )
      end
    end
    let(:player) do
      lambda do |eco|
        Factory.create(:player_no_home_ss,
          galaxy: galaxy, economy_points: eco, science_points: 0,
          army_points: 0, war_points: 0
        )
      end
    end

    before(:each) do
      Cfg.stub(:galaxy_zone_diameter).and_return(8)
      Cfg.stub(:galaxy_zone_max_player_count).and_return(3)
    end

    it "should return zone where player points avg is closest" do
      ss[1, 0, 900]   # Q4, Slot 1
      ss[10, 0, 500]  # Q4, Slot 2
      ss[10, 1, 1500] # Q4, Slot 2
      ss[1, 9, 1100]  # Q4, Slot 3

      Galaxy::Zone.for_reattachment(galaxy.id, player_points).should ==
        Galaxy::Zone.new(2, 4)
    end

    it "should not include detached systems" do
      ss[nil, nil, player_points]
      ss[10, 0, 500] # Q4, Slot 2
      Galaxy::Zone.for_reattachment(galaxy.id, player_points).should ==
        Galaxy::Zone.new(2, 4)
    end

    it "should not include systems from other galaxies" do
      ss[1, 0, player_points].tap do |s|
        s.galaxy = Factory.create(:galaxy)
        s.save!
      end
      ss[10, 0, 500] # Q4, Slot 2
      Galaxy::Zone.for_reattachment(galaxy.id, player_points).should ==
        Galaxy::Zone.new(2, 4)
    end

    it "should filter out zones that have >= than max players" do
      (0...Cfg.galaxy_zone_max_player_count).each do |y|
        ss[1, y, player_points]
      end
      ss[10, 0, 500] # Q4, Slot 2
      Galaxy::Zone.for_reattachment(galaxy.id, player_points).should ==
        Galaxy::Zone.new(2, 4)
    end

    it "should pass its job to .for_enrollment if there are no players" do
      Galaxy::Zone.should_receive(:for_enrollment).with(galaxy.id, nil).
        and_return(:zone)
      Galaxy::Zone.for_reattachment(galaxy.id, player_points).should == :zone
    end
  end

  describe ".for_enrollment" do
    let(:galaxy) { Factory.create(:galaxy) }
    let(:ss) do
      lambda do |x, y, player|
        Factory.create(
          :solar_system, galaxy: galaxy, x: x, y: y, player: player
        )
      end
    end
    let(:player) do
      lambda do |age|
        Factory.create(
          :player_no_home_ss, galaxy: galaxy, created_at: age.hours.ago
        )
      end
    end

    before(:each) do
      Cfg.stub(:galaxy_zone_diameter).and_return(8)
      Cfg.stub(:galaxy_zone_max_player_count).and_return(3)
    end

    it "should return zone with free spots" do
      # Q4, Slot 1, full
      ss[0, 0, player[1]]; ss[0, 1, player[1]]; ss[0, 2, player[1]]
      # Q1, Slot 2, free
      ss[8, -1, player[1]]

      Galaxy::Zone.for_enrollment(galaxy.id, nil).should ==
        Galaxy::Zone.new(2, 1)
    end

    it "should return zone with lowest spot number" do
      # Q4, Slot 1, free
      ss[0, 0, player[1]]; ss[0, 1, player[1]]
      # Q1, Slot 2, free
      ss[8, -1, player[1]]

      Galaxy::Zone.for_enrollment(galaxy.id, nil).should ==
        Galaxy::Zone.new(1, 4)
    end

    it "should raise error if no free zones exist" do
      lambda do
        Galaxy::Zone.for_enrollment(galaxy.id, nil)
      end.should raise_error(RuntimeError)
    end

    describe "max_age=nil" do
      it "should ignore player age" do
        # Q4, Slot 1, full
        ss[0, 0, player[10]]; ss[0, 1, player[5]]
        # Q1, Slot 2, free
        ss[8, -1, player[3]]

        Galaxy::Zone.for_enrollment(galaxy.id, nil).should ==
          Galaxy::Zone.new(1, 4)
      end
    end

    describe "max_age=Fixnum" do
      it "should skip zones where at least one player is old enough" do
        # Q4, Slot 1, full
        ss[0, 0, player[10]]; ss[0, 1, player[5]]
        # Q1, Slot 2, free
        ss[8, -1, player[1]]

        Galaxy::Zone.for_enrollment(galaxy.id, 2.hours).should ==
          Galaxy::Zone.new(2, 1)
      end
    end
  end
end