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

    describe "listing" do
      describe "planets" do
        it "should include them with resources if friendly" do
          planet = Factory.create(:planet, :solar_system => @solar_system,
            :player => player)

          invoke @action, @params
          response[:ss_objects].should include(
            planet.as_json(:resources => true, :perspective => player))
        end

        it "should include them without resources if not friendly" do
          planet = Factory.create(:planet, :solar_system => @solar_system,
            :player => Factory.create(:player))

          invoke @action, @params
          response[:ss_objects].should include(
            planet.as_json(:resources => false, :perspective => player)
          )
        end

        it "should include them with unknown status if npc" do
          planet = Factory.create(:planet, :solar_system => @solar_system)

          invoke @action, @params
          response[:ss_objects].should include(
            planet.as_json(:resources => false, :perspective => player)
          )
        end
      end

      describe "asteroids" do
        before(:each) do
          @asteroid = Factory.create(:sso_asteroid,
            :solar_system => @solar_system)
        end

        it "should include them with resources" do
          invoke @action, @params
          response[:ss_objects].should include(
            @asteroid.as_json(:resources => true))
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
      response_should_include(:solar_system => @solar_system)
    end

    it "should return battleground if we requested to view a wormhole" do
      wormhole = Factory.create :solar_system, :galaxy => player.galaxy,
        :wormhole => true
      Factory.create :fse_player, :solar_system => wormhole,
        :player => player
      battleground = Factory.create(:solar_system, :galaxy => player.galaxy,
        :x => nil, :y => nil)
      invoke @action, @params.merge('id' => wormhole.id)
      response_should_include(:solar_system => battleground)
    end

    it "should store current solar system id" do
      lambda do
        invoke @action, @params
      end.should change(@controller, :current_ss_id).to(@solar_system.id)
    end

    it "should clear current planet id" do
      @controller.current_planet_id = 10
      lambda do
        invoke @action, @params
      end.should change(@controller, :current_planet_id).from(10).to(nil)
    end

    it "should not clear current planet id if it's the same ss" do
      @controller.current_ss_id = @solar_system.id
      @controller.current_planet_id = 10
      lambda do
        invoke @action, @params
      end.should_not change(@controller, :current_planet_id)
    end

    it "should not allow viewing ss where player has no vision" do
      SolarSystem.should_receive(:find_if_visible_for).with(@solar_system.id,
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

      it "should include route hops" do
        invoke @action, @params
        response_should_include(
          :route_hops => RouteHop.find_all_for_player(player, @zone, [@unit])
        )
      end
    end
  end
end