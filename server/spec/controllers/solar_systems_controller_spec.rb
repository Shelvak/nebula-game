require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe SolarSystemsController do
  include ControllerSpecHelper

  before(:each) do
    init_controller SolarSystemsController, :login => true
  end

  describe "solar_systems|index" do
    before(:each) do
      @action = "solar_systems|index"
      @params = {}

      Factory.create :fge_player, :player => player,
        :rectangle => Rectangle.new(0, 0, 2, 2)
      Factory.create :fge_player, :player => player,
        :rectangle => Rectangle.new(2, 2, 4, 4)
      # Visible units
      @unit1 = Factory.create :u_mule, :location => GalaxyPoint.new(
        player.galaxy_id, 0, 1)
      @unit2 = Factory.create :u_mule, :location => GalaxyPoint.new(
        player.galaxy_id, 3, 3)
      # Invisible unit
      @unit3 = Factory.create :u_mule, :location => GalaxyPoint.new(
        player.galaxy_id, 0, 3)
    end

    it "should allow listing visible SS in galaxy" do
      visible_solar_systems = :visible_ss
      SolarSystem.stub!(:visible_for).with(player).and_return(
        visible_solar_systems
      )

      invoke @action, @params
      response_should_include(
        :solar_systems => visible_solar_systems
      )
    end

    it "should include units" do
      invoke @action, @params
      response[:units].should == StatusResolver.new(player).resolve_objects(
        Galaxy.units(player)
      )
    end

    it "should include route hops" do
      invoke @action, @params
      response_should_include(
        :route_hops => RouteHop.find_all_for_player(player, player.galaxy,
          [@unit1, @unit2]
        )
      )
    end

    it "should include fow galaxy entries" do
      invoke @action, @params
      response[:fow_entries].should == FowGalaxyEntry.for(player)
    end
  end
end