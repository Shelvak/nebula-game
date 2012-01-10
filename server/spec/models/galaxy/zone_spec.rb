require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Galaxy::Zone do
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
end