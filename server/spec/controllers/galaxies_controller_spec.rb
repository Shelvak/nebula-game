require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe GalaxiesController do
  include ControllerSpecHelper

  before(:each) do
    init_controller GalaxiesController, :login => true
  end

  describe "galaxies|show" do
    before(:each) do
      @action = "galaxies|show"
      @params = {}

      @battleground = Factory.create(:battleground, :galaxy => player.galaxy)
      Factory.create :fge_player, :player => player,
        :galaxy => player.galaxy,
        :rectangle => Rectangle.new(0, 0, 2, 2)
      Factory.create :fge_player, :player => player,
        :galaxy => player.galaxy,
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
    
    it_behaves_like "only push"

    it "should include galaxy id" do
      push @action, @params
      response_should_include :galaxy_id => player.galaxy_id
    end

    it "should allow listing visible SS in galaxy" do
      visible_solar_systems = :visible_ss
      SolarSystem.stub!(:visible_for).with(player).and_return(
        visible_solar_systems
      )

      push @action, @params
      response_should_include(
        :solar_systems => visible_solar_systems.as_json
      )
    end

    it "should include battleground id" do
      push @action, @params
      response[:battleground_id].should == @battleground.id
    end

    it "should include units" do
      push @action, @params
      resolver = StatusResolver.new(player)
      response[:units].should == Galaxy.units(player).map do |unit|
        unit.as_json(:perspective => resolver)
      end
    end

    it "should include players" do
      push @action, @params
      response[:players].should equal_to_hash(
        Player.minimal_from_objects(Galaxy.units(player))
      )
    end

    it "should include non friendly route jumps_at hash" do
      FowGalaxyEntry.stub!(:for).with(player).and_return([
        Factory.create(:fge_player, :galaxy => player.galaxy)
      ])
      routes = [Factory.create(:route, :jumps_at => 5.minutes.from_now)]
      Route.should_receive(:non_friendly_for_galaxy).with(
        FowGalaxyEntry.for(player), player.friendly_ids
      ).and_return(routes)
      push @action, @params
      response_should_include(
        :non_friendly_jumps_at => Route.jumps_at_hash_from_collection(routes)
      )
    end

    it "should include route hops" do
      push @action, @params
      response_should_include(
        :route_hops => RouteHop.find_all_for_player(player, player.galaxy,
          [@unit1, @unit2]
        )
      )
    end

    it "should include fow galaxy entries" do
      push @action, @params
      response[:fow_entries].should == FowGalaxyEntry.for(player).map(
        &:as_json)
    end

    describe "in visible zone" do
      before(:each) do
        Factory.create(:fge_player,
          :rectangle => Rectangle.new(0, 0, 4, 4),
          :galaxy => player.galaxy,
          :player => player)
      end

      describe "visible" do
        before(:each) do
          @location = GalaxyPoint.new(player.galaxy_id, 0, 0)
        end

        it "should include wreckages" do
          wreckage = Factory.create(:wreckage, :location => @location)
          push @action, @params
          response[:wreckages].should include(wreckage.as_json)
        end

        it "should include cooldowns" do
          cooldown = Factory.create(:cooldown, :location => @location)
          push @action, @params
          response[:cooldowns].should include(cooldown.as_json)
        end
      end

      describe "invisible" do
        before(:each) do
          @location = GalaxyPoint.new(player.galaxy_id, -1, 0)
        end

        it "should not include wreckages" do
          wreckage = Factory.create(:wreckage, :location => @location)
          push @action, @params
          response[:wreckages].should_not include(wreckage.as_json)
        end

        it "should not include cooldowns" do
          cooldown = Factory.create(:cooldown, :location => @location)
          push @action, @params
          response[:cooldowns].should_not include(cooldown.as_json)
        end
      end
    end
  end

  describe "galaxies|apocalypse" do
    before(:each) do
      @action = "galaxies|apocalypse"
      @params = {'start' => 15.minutes.from_now}
      @method = :push
    end

    it_should_behave_like "with param options", %w{start}

    it_should_behave_like "only push"

    it "should respond with start time" do
      push @action, @params
      response_should_include(
        :start => @params['start']
      )
    end
  end
end