require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "visible planet", :shared => true do
  it "should include planet" do
    response_should_include(:planet => @planet)
  end

  it "should set currently viewed planet" do
    @controller.current_planet_id.should == @planet.id
  end

  it "should set currently viewed solar system id" do
    @controller.current_ss_id.should == @planet.solar_system_id
  end

  it "should include tiles" do
    response_should_include(
      :tiles => Tile.fast_find_all_for_planet(@planet)
    )
  end

  it "should include folliages" do
    response_should_include(
      :folliages => Folliage.fast_find_all_for_planet(@planet)
    )
  end

  it "should include buildings" do
    response_should_include(:buildings => @planet.buildings)
  end

  it "should include units" do
    response_should_include(
      :units => StatusResolver.new(player).resolve_objects(@planet.units)
    )
  end
end

describe PlanetsController do
  include ControllerSpecHelper

  before(:each) do
    init_controller PlanetsController, :login => true
  end

  describe "planets|index" do
    before(:each) do
      @action = "planets|index"
      @solar_system = Factory.create :ss_expansion,
        :create_empty => false,
        :galaxy => player.galaxy
      @params = {'solar_system_id' => @solar_system.id}
    end

    it "should allow listing planets for given solar system" do
      Factory.create :fse_player, :solar_system => @solar_system,
        :player => player

      planet = @solar_system.planets.first
      planet.player = player
      planet.save!

      invoke @action, @params
      response_should_include(:planets => @solar_system.planets)
    end

    it "should return solar system" do
      Factory.create :fse_player, :solar_system => @solar_system,
        :player => player

      invoke @action, @params
      response_should_include(:solar_system => @solar_system)
    end

    it "should store current solar system id" do
      Factory.create :fse_player, :solar_system => @solar_system,
        :player => player

      lambda do
        invoke @action, @params
      end.should change(@controller, :current_ss_id).to(@solar_system.id)
    end

    it "should clear current planet id" do
      Factory.create :fse_player, :solar_system => @solar_system,
        :player => player

      @controller.current_planet_id = 10
      lambda do
        invoke @action, @params
      end.should change(@controller, :current_planet_id).from(10).to(nil)
    end

    it "should not clear current planet id if it's the same ss" do
      Factory.create :fse_player, :solar_system => @solar_system,
        :player => player

      @controller.current_ss_id = @solar_system.id
      @controller.current_planet_id = 10
      lambda do
        invoke @action, @params
      end.should_not change(@controller, :current_planet_id)
    end

    it "should not allow listing planets where player has no vision" do
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    describe "visible units in solar system" do
      before(:each) do
        @zone = @solar_system

        Factory.create :fse_player, :solar_system => @solar_system,
          :player => player, :player_planets => true
        @unit = Factory.build :u_crow
        @unit.location = SolarSystemPoint.new(@solar_system.id, 1, 0)
        @unit.save!
      end

      it "should allow viewing units where you have visibility" do
        invoke @action, @params
        resolver = StatusResolver.new(player)
        response_should_include(:units => resolver.resolve_objects([@unit]))
      end
      
      it "should include route hops" do
        invoke @action, @params
        response_should_include(
          :route_hops => RouteHop.find_all_for_player(player, @zone, [@unit])
        )
      end
    end

    describe "units present but not visible" do
      before(:each) do
        Factory.create :fse_player, :solar_system => @solar_system,
          :player => player, :player_planets => false,
          :player_ships => false

        unit = Factory.build :u_crow
        unit.location = SolarSystemPoint.new(@solar_system.id, 1, 0)
        unit.save!
      end

      it "should not allow viewing units" do
        invoke @action, @params
        response_should_include(:units => [])
      end

      it "should not allow route_hops" do
        invoke @action, @params
        response_should_include(:route_hops => [])
      end
    end
  end

  describe "planets|show" do
    before(:each) do
      @action = "planets|show"
    end

    it "should not allow player to view it if not in observable list" do
      planet = Factory.create :planet
      SsObject.stub!(:find).with(planet.id).and_return(planet)
      planet.stub!(:observer_player_ids).and_return([])
      lambda do
        invoke @action, 'id' => planet.id
      end.should raise_error(GameLogicError)
    end

    describe "visible planet (via units)" do
      before(:all) do
        @enemy = Factory.create(:player)
        @planet = Factory.create :planet, :create_empty => false,
          :player => @enemy
        @params = {'id' => @planet.id}
      end

      before(:each) do
        @unit = Factory.create :unit, :location => @planet,
          :player => player
        invoke @action, @params
      end

      it_should_behave_like "visible planet"

      it "should not push resources" do
        should_not_push ResourcesController::ACTION_INDEX,
          'resources_entry' => @planet.resources_entry
        invoke @action, @params
      end
    end

    describe "visible planet (via owning)" do
      before(:all) do
        @planet = Factory.create :planet, :create_empty => false
        @params = {'id' => @planet.id}
      end

      before(:each) do
        @planet.player = player
        @planet.save!
        invoke @action, @params
      end

      it_should_behave_like "visible planet"

      it "should push resources" do
        should_push ResourcesController::ACTION_INDEX,
          'resources_entry' => @planet.resources_entry
        invoke @action, @params
      end
    end
  end

  describe "planets|player_index" do
    before(:each) do
      @action = "planets|player_index"
      @params = {}
    end

    it_should_behave_like "only push"

    it "should return players planets" do
      planet0 = Factory.create :planet_with_player
      planet1 = Factory.create :planet_with_player,
        :player => player
      planet2 = Factory.create :planet_with_player,
        :player => player
      planet3 = Factory.create :planet_with_player

      should_respond_with :planets => [planet1, planet2]
      push @action, @params
    end
  end
end