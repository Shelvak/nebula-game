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

  describe ".list_for" do
    let(:galaxy) { Factory.create(:galaxy) }

    def ss_in(x, y, with_player)
      Factory.create(:solar_system, :galaxy => galaxy, :x => x, :y => y,
        :player => with_player ? Factory.create(:player_for_ratings) : nil)
    end

    def solar_systems(with_players=true)
      diam = Cfg.galaxy_zone_diameter
      wp = with_players
      srand(121223) # Seed random to get predictable test results.
      ss = {
        # 2 ss in 1st slot, 1 in 3rd.
        1 => [ss_in(0, -1, wp), ss_in(1,-2, wp), ss_in(0, -diam - 1, wp)],
        2 => [ss_in(-1, -1, wp), ss_in(-2, -2, wp), ss_in(-1, -diam - 1, wp)],
        3 => [ss_in(-1, 1, wp), ss_in(-2, 2, wp), ss_in(-1, diam, wp)],
        4 => [ss_in(0, 0, wp), ss_in(1, 1, wp), ss_in(0, diam, wp)]
      }
      srand(Time.now.to_i) # Restore randomness
      ss
    end

    def expected_row(quarter, slot, solar_systems, target_points)
      {
        'quarter' => quarter, 'slot' => slot,
        'points_diff' => (
          solar_systems.map { |ss| ss.try(:player).try(:points) || 0 }.average -
          target_points
        ).abs.round,
        'player_count' => solar_systems.map(&:player_id).compact.size
      }
    end

    def create_expected(solar_systems, target_points)
      solar_systems.keys.each_with_object([]) do |quarter, array|
        array << expected_row(
          quarter, 1, solar_systems[quarter][0..1], target_points
        )
        array << expected_row(
          quarter, 3, solar_systems[quarter][2..2], target_points
        )
      end.sort_by { |row| [row['points_diff'], row['quarter'], row['slot']] }
    end

    it "should return zone averages" do
      solar_systems = solar_systems()
      target_points = 1000

      expected = create_expected(solar_systems, target_points)

      rows = Galaxy::Zone.list_for(galaxy.id, target_points)
      rows.should == expected
    end

    it "should include non-home solar systems if no player systems are found" do
      break_transaction
      solar_systems = solar_systems(false)
      target_points = 1000

      expected = create_expected(solar_systems, target_points)

      rows = Galaxy::Zone.list_for(galaxy.id, target_points)
      rows.should == expected
    end

    it "should raise exception if no systems are found at all" do
      lambda do
        Galaxy::Zone.list_for(galaxy.id)
      end.should raise_error(RuntimeError)
    end
  end

  describe ".for_reattachment" do
    let(:galaxy_id) { 10 }
    let(:target_points) { 12356 }

    it "should return first zone from the list" do
      Galaxy::Zone.stub(:list_for).with(galaxy_id, target_points).and_return([
        {'quarter' => 3, 'slot' => 1, 'points_diff' => 1, 'player_count' => 0},
        {'quarter' => 2, 'slot' => 1, 'points_diff' => 1, 'player_count' => 0},
      ])
      zone = Galaxy::Zone.for_reattachment(galaxy_id, target_points)
      [zone.slot, zone.quarter].should == [1, 3]
    end

    it "should skip zones if they are full" do
      Galaxy::Zone.stub(:list_for).with(galaxy_id, target_points).and_return([
        {'quarter' => 3, 'slot' => 1, 'points_diff' => 1,
         'player_count' => Cfg.galaxy_zone_max_player_count},
        {'quarter' => 2, 'slot' => 1, 'points_diff' => 1, 'player_count' => 0},
      ])
      zone = Galaxy::Zone.for_reattachment(galaxy_id, target_points)
      [zone.slot, zone.quarter].should == [1, 2]
    end

    it "should create new zone if all zones are full" do
      galaxy = Factory.create(:galaxy)
      Galaxy::Zone.stub(:list_for).with(galaxy.id, target_points).and_return([
        {'quarter' => 3, 'slot' => 1, 'points_diff' => 1,
         'player_count' => Cfg.galaxy_zone_max_player_count},
        {'quarter' => 2, 'slot' => 1, 'points_diff' => 1,
         'player_count' => Cfg.galaxy_zone_max_player_count},
      ])

      quarter = 2
      slot = 2

      SpaceMule.instance.should_receive(:create_zone).
        with(galaxy.id, galaxy.ruleset, slot, quarter)
      zone = Galaxy::Zone.for_reattachment(galaxy.id, target_points)
      [zone.slot, zone.quarter].should == [slot, quarter]
    end
  end
end