require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe UnitBuilder do
  describe ".from_random_ranges" do
    before(:all) do
      @definition = [
        ["4 + 2 * counter / spot", "8 + 4 * counter / spot", "Dirac", 0],
        ["4 + 2 * counter / spot", "12 + 6 * counter / spot", "Dirac", 1],
        ["2 + counter / spot", "6 + 3 * counter / spot", "Thor", 0],
        ["4 + 2 * counter / spot", "8 + 4 * counter / spot", "Thor", 1],
        ["2 + counter / spot", "6 + 3 * counter / spot", "Demosis", 0],
        ["2 + counter / spot", "6 + 3 * counter / spot", "Demosis", 1]
      ]
      galaxy = Factory.create(:galaxy)
      @location = GalaxyPoint.new(galaxy.id, 10, 20)
      @player = Factory.create(:player, :galaxy => galaxy)
      @counter = 38
      @spot = 1
      @units = UnitBuilder.from_random_ranges(
        @definition, @location, @player.id, @counter, @spot
      )
      Unit.save_all_units(@units)
    end

    it "should set #location" do
      @units.map(&:location).uniq.should == [@location]
    end

    it "should set #player_id" do
      @units.map(&:player_id).uniq.should == [@player.id]
    end

    it "should conform to definition" do
      check_spawned_units_by_random_definition(
        @definition, @location, @player.id, @counter, @spot
      )
    end
  end
end