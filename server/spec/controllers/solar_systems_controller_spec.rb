require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe SolarSystemsController do
  include ControllerSpecHelper

  before(:each) do
    init_controller SolarSystemsController, :login => true
  end

  describe "solar_systems|show" do
    before(:each) do
      @action = "solar_systems|show"
      @solar_system = Factory.create :solar_system, :galaxy => player.galaxy
      @fse = Factory.create :fse_player, :solar_system => @solar_system,
        :player => player

      @params = {'id' => @solar_system.id}
    end

    it_should_behave_like "having controller action scope"

    describe "listing" do
      describe "planets" do
        it "should include them" do
          planet = Factory.create(:planet, :solar_system => @solar_system)

          invoke @action, @params
          response[:ss_objects].should include(
            planet.as_json(:perspective => player)
          )
        end
      end

      describe "asteroids" do
        before(:each) do
          @asteroid = Factory.create(:sso_asteroid,
            :solar_system => @solar_system)
        end

        it "should include them" do
          invoke @action, @params
          response[:ss_objects].should include(@asteroid.as_json)
        end
      end

      describe "jumpgates" do
        it "should include them" do
          jg = Factory.create(:sso_jumpgate,
            :solar_system => @solar_system)
          invoke @action, @params
          response[:ss_objects].should include(jg.as_json)
        end
      end

      it "should include wreckages" do
        Factory.create(:wreckage,
          :location => SolarSystemPoint.new(@solar_system.id, 0, 0))
        invoke @action, @params
        response[:wreckages].should == Wreckage.in_zone(
          @solar_system).all.map(&:as_json)
      end

      it "should include cooldowns" do
        Factory.create(:cooldown,
          :location => SolarSystemPoint.new(@solar_system.id, 0, 0))
        invoke @action, @params
        response[:cooldowns].should == Cooldown.in_zone(
          @solar_system).all.map(&:as_json)
      end
    end

    it "should allow listing ss objects for given solar system" do
      invoke @action, @params
      response_should_include(:ss_objects => @solar_system.ss_objects)
    end

    it "should return solar system" do
      invoke @action, @params
      response_should_include(:solar_system => @solar_system.as_json)
    end

    it "should return battleground if we requested to view a wormhole" do
      wormhole = Factory.create :wormhole, :galaxy => player.galaxy
      Factory.create :fse_player, :solar_system => wormhole,
        :player => player
      battleground = Factory.create(:solar_system, :galaxy => player.galaxy,
        :x => nil, :y => nil)
      invoke @action, @params.merge('id' => wormhole.id)
      response_should_include(:solar_system => battleground.as_json)
    end

    it "should store current solar system id" do
      lambda do
        invoke @action, @params
      end.should change(self, :current_ss_id).to(@solar_system.id)
    end

    %w{current_planet_id current_planet_ss_id}.each do |attr|
      it "should clear #{attr} if we opened other ss than planet is in" do
        self.current_planet_ss_id = @solar_system.id + 1
        self.current_planet_id = 10
        lambda do
          invoke @action, @params
        end.should change(self, attr).to(nil)
      end

      it "should keep #{attr} if we opened same ss that planet is in" do
        self.current_planet_ss_id = @solar_system.id
        self.current_planet_id = 10
        lambda do
          invoke @action, @params
        end.should_not change(self, attr)
      end
    end

    it "should not allow viewing ss where player has no vision" do
      SolarSystem.should_receive(:find_if_viewable_for).with(@solar_system.id,
        player).and_raise(ActiveRecord::RecordNotFound)
      
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    describe "visible units in solar system" do
      before(:each) do
        @zone = @solar_system

        @fse.player_planets = true
        @fse.save!

        @unit = Factory.build :u_crow
        @unit.location = SolarSystemPoint.new(@solar_system.id, 1, 0)
        @unit.save!
      end

      it "should allow viewing units where you have visibility" do
        invoke @action, @params
        resolver = StatusResolver.new(player)
        response_should_include(:units => [
            @unit.as_json(:perspective => resolver)])
      end

      it "should include players" do
        invoke @action, @params
        response_should_include(:players =>
            {@unit.player_id => Player.minimal(@unit.player_id)})
      end

      it "should include non-friendly route jumps_at" do
        routes = [Factory.create(:route)]
        Route.should_receive(:non_friendly_for_solar_system).with(
          @solar_system.id, player.friendly_ids
        ).and_return(routes)
        invoke @action, @params
        response_should_include(
          :non_friendly_jumps_at => Route.jumps_at_hash_from_collection(routes)
        )
      end

      it "should include route hops" do
        route_hops = [Factory.create(:route_hop)]
        RouteHop.should_receive(:find_all_for_player).
          with(player, @zone, [@unit]).and_return(route_hops)
        invoke @action, @params
        response_should_include(
          :route_hops => route_hops.map(&:as_json)
        )
      end
    end
  end
end
