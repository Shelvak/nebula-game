require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe UnitBuilder do
  describe ".from_random_ranges" do
    before(:all) do
      @definition = Cfg.galaxy_convoy_units_definition
      galaxy = Factory.create(:galaxy)
      @galaxy_id = galaxy.id
      @location = GalaxyPoint.new(@galaxy_id, 10, 20)
      @player = Factory.create(:player, :galaxy => galaxy)
      @units = UnitBuilder.from_random_ranges(
        @definition, @galaxy_id, @location, @player.id
      )
      Unit.save_all_units(@units)
    end

    it "should set #galaxy_id" do
      @units.map(&:galaxy_id).uniq.should == [@galaxy_id]
    end

    it "should set #location" do
      @units.map(&:location).uniq.should == [@location]
    end

    it "should set #player_id" do
      @units.map(&:player_id).uniq.should == [@player.id]
    end

    it "should conform to definition" do
      check_spawned_units_by_random_definition(
        @definition, @galaxy_id, @location, @player.id
      )
    end
  end
end