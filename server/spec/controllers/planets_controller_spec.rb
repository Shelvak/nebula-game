require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

def create_planet(player)
  planet = Factory.create(:planet, :player => player)
  Factory.create(:tile, :planet => planet)
  Factory.create(:folliage, :planet => planet)
  Factory.create(:building, :planet => planet)
  Factory.create(:unit, :location => planet, :player => player)

  planet
end

describe "visible planet", :shared => true do
  it "should set currently viewed planet" do
    @controller.current_planet_id.should == @planet.id
  end

  it "should set currently viewed planet ss id" do
    @controller.current_planet_ss_id.should == @planet.solar_system_id
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
    response_should_include(:buildings => @planet.buildings.map(&:as_json))
  end

  it "should include units" do
    resolver = StatusResolver.new(player)
    response_should_include(
      :units => @planet.units.map {
        |unit| unit.as_json(:perspective => resolver) }
    )
  end

  it "should include players" do
    response_should_include(
      :players => Player.minimal_from_objects(@planet.units)
    )
  end
end

describe PlanetsController do
  include ControllerSpecHelper

  before(:each) do
    init_controller PlanetsController, :login => true
  end

  describe "planets|show" do
    before(:each) do
      @action = "planets|show"
    end

    it "should not allow player to view it if not in observable list" do
      planet = Factory.create :planet
      SsObject::Planet.stub!(:find).with(planet.id).and_return(planet)
      planet.stub!(:observer_player_ids).and_return([])
      lambda do
        invoke @action, 'id' => planet.id
      end.should raise_error(GameLogicError)
    end

    describe "visible planet" do
      before(:each) do
        @planet = create_planet(player)
        SsObject::Planet.stub!(:find).with(@planet.id).and_return(@planet)

        @npc_building = Factory.create(:b_npc_solar_plant, :x => 10,
          :planet => @planet)
        @npc_unit = Factory.create(:u_gnat, :location => @npc_building)

        @params = {'id' => @planet.id}
      end

      it "should include cooldown" do
        ends_at = :ends_at
        Cooldown.should_receive(:for_planet).with(@planet).and_return(
          ends_at)
        invoke @action, @params
        response_should_include(:cooldown_ends_at => ends_at.as_json)
      end

      it "should clear currently viewed solar system id if it is different" do
        @controller.current_ss_id = -1
        invoke @action, @params
        @controller.current_ss_id.should be_nil
      end

      it "should keep currently viewed solar system id if it is same" do
        @controller.current_ss_id = @planet.solar_system_id
        invoke @action, @params
        @controller.current_ss_id.should == @planet.solar_system_id
      end

      describe "without resources" do
        before(:each) do
          @planet.stub!(:can_view_resources?).with(player.id).and_return(
            false)
          invoke @action, @params
        end

        it_should_behave_like "visible planet"

        it "should include planet without resources" do
          response_should_include(
            :planet => @planet.as_json(:resources => false, :view => true)
          )
        end
      end

      describe "with resources" do
        before(:each) do
          @planet.stub!(:can_view_resources?).with(player.id).and_return(
            true)
          invoke @action, @params
        end

        it_should_behave_like "visible planet"

        it "should include planet with resources" do
          response_should_include(
            :planet => @planet.as_json(:resources => true, :view => true)
          )
        end
      end

      describe "without npc units" do
        before(:each) do
          @planet.stub!(:can_view_npc_units?).with(player.id).and_return(
            false)
          invoke @action, @params
        end

        it_should_behave_like "visible planet"

        it "should not include npc units" do
          response_should_include(:npc_units => [])
        end
      end

      describe "with npc units" do
        before(:each) do
          @planet.stub!(:can_view_npc_units?).with(player.id).and_return(
            true)
          invoke @action, @params
        end

        it_should_behave_like "visible planet"

        it "should include npc units" do
          response_should_include(
            :npc_units => [@npc_unit.as_json]
          )
        end
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

      push @action, @params
      # Try to account for time difference
      planet1.reload; planet2.reload
      response_should_include(:planets => ([planet1, planet2].map do |planet|
        planet.as_json(:resources => true)
      end))
    end
  end

  describe "planets|explore" do
    before(:each) do
      @action = "planets|explore"
      @planet = Factory.create(:planet, :player => player)
      @rc = Factory.create(:b_research_center, :planet => @planet)
      @x = 10; @y = 16
      @folliage = Factory.create(:block_tile, :kind => Tile::FOLLIAGE_3X4,
        :x => @x, :y => @y, :planet => @planet)
      @params = {'planet_id' => @planet.id, 'x' => @x, 'y' => @y}
    end

    @required_params = %w{planet_id x y}
    it_should_behave_like "with param options"

    it "should fail if planet does not belong to player" do
      @planet.player = nil
      @planet.save!
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if planet is not found" do
      @planet.destroy
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should not fail if there is no research centers but we have a " +
    "mothership" do
      @rc.destroy
      Factory.create(:b_mothership, :planet => @planet)
      lambda do
        invoke @action, @params
      end.should_not raise_error(GameLogicError)
    end

    it "should fail if there is no research centers" do
      @rc.destroy
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail if there is an upgrading research center" do
      @rc.level = 0; @rc.hp = 0; @rc.save!
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should call explore! on planet" do
      invoke @action, @params
      @planet.reload
      @planet.should be_exploring
    end
  end

  describe "planets|edit" do
    before(:each) do
      @action = "planets|edit"
      @planet = Factory.create(:planet, :player => player)
      @mothership = Factory.create(:b_mothership, :planet => @planet)
      @params = {'id' => @planet.id, 'name' => "FooPlanet"}
    end

    @required_params = %w{id}
    it_should_behave_like "with param options"

    it "should fail if you are not the planet owner" do
      @planet.player = Factory.create(:player)
      @planet.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if you do not have mothership" do
      @mothership.destroy
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should not fail if you have headquarters" do
      @mothership.destroy
      Factory.create(:b_headquarters, :planet => @planet)
      lambda do
        invoke @action, @params
      end.should_not raise_error(GameLogicError)
    end

    it "should push changed" do
      should_fire_event(@planet, EventBroker::CHANGED) do
        invoke @action, @params
      end
    end

    it "should change name if provided" do
      lambda do
        invoke @action, @params
        @planet.reload
      end.should change(@planet, :name).to(@params['name'])
    end

    it "should not change name if not provided" do
      lambda do
        invoke @action, @params.merge('name' => nil)
        @planet.reload
      end.should_not change(@planet, :name)
    end
  end
end