require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

def create_planet(player)
  planet = Factory.create(:planet, :player => player)
  Factory.create(:tile, :planet => planet)
  Factory.create(:folliage, :planet => planet)
  Factory.create(:building, :planet => planet)
  Factory.create(:unit, :location => planet, :player => player)

  planet
end

shared_examples_for "visible planet" do
  it "should set currently viewed planet" do
    current_planet_id.should == @planet.id
  end

  it "should set currently viewed planet ss id" do
    current_planet_ss_id.should == @planet.solar_system_id
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

    it_should_behave_like "having controller action scope"

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
        self.current_ss_id = -1
        invoke @action, @params
        current_ss_id.should be_nil
      end

      it "should keep currently viewed solar system id if it is same" do
        self.current_ss_id = @planet.solar_system_id
        invoke @action, @params
        current_ss_id.should == @planet.solar_system_id
      end

      describe "without owner attributes" do
        before(:each) do
          @planet.player = Factory.create(:player)
          Factory.create(:u_trooper, :location => @planet, :player => player,
            :level => 1)
          invoke @action, @params
        end

        it_behaves_like "visible planet"

        it "should include planet without resources" do
          response_should_include(
            :planet => @planet.as_json(:owner => false, :view => true,
                                       :perspective => player)
          )
        end
      end

      describe "with owner attributes" do
        before(:each) do
          @planet.player = player
          invoke @action, @params
        end

        it_behaves_like "visible planet"

        it "should include planet with resources" do
          response_should_include(
            :planet => @planet.as_json(:owner => true, :view => true,
                                       :perspective => player)
          )
        end
      end

      it "should include non-friendly route jumps_at" do
        routes = [Factory.create(:route)]
        Route.should_receive(:non_friendly_for_ss_object).with(
          @planet.id, player.friendly_ids
        ).and_return(routes)
        invoke @action, @params
        response_should_include(
          :non_friendly_jumps_at => Route.jumps_at_hash_from_collection(routes)
        )
      end
    end
  end

  describe "planets|unset_current" do
    before(:each) do
      @action = "planets|unset_current"
      @params = {}
      self.current_planet_id = 10
      self.current_planet_ss_id = 100
    end

    it_should_behave_like "only push"
    it_should_behave_like "having controller action scope"

    it "should unset current planet id" do
      push @action, @params
      self.current_planet_id.should be_nil
    end

    it "should unset current planet ss id" do
      push @action, @params
      self.current_planet_ss_id.should be_nil
    end

    it "should reply with success: true" do
      push @action, @params
      response.should == {success: true}
    end
  end

  describe "planets|player_index" do
    before(:each) do
      @action = "planets|player_index"
      @params = {}
    end

    it_behaves_like "only push"
    it_should_behave_like "having controller action scope"

    it "should return players planets" do
      planet0 = Factory.create :planet_with_player
      planet1 = Factory.create :planet_with_player,
        :player => player
      planet2 = Factory.create :planet_with_player,
        :player => player
      planet3 = Factory.create :planet_with_player

      push @action, @params
      # Try to account for time difference
      [planet1, planet2].each_with_index do |planet, index|
        planet.reload
        response[:planets][index].should equal_to_hash(
          planet.as_json(:index => true, :view => true))
      end
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

    it_behaves_like "with param options", %w{planet_id x y}
    it_should_behave_like "having controller action scope"

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

  describe "planets|finish_exploration" do
    before(:each) do
      @action = "planets|finish_exploration"
      @planet = Factory.create(:planet, :player => player, 
        :exploration_x => 5, :exploration_y => 3, 
        :exploration_ends_at => 10.minutes.from_now)
      Factory.create(:t_folliage_3x4, :planet => @planet, 
        :x => @planet.exploration_x, :y => @planet.exploration_y)
      @params = {'id' => @planet.id}
    end
    
    it_behaves_like "with param options", %w{id}
    it_should_behave_like "having controller action scope"
    
    it "should fail if a planet does not belong to player" do
      @planet.update_row! ["player_id=?", Factory.create(:player).id]
      
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
    
    it "should finish exploration" do
      SsObject::Planet.stub_chain(:where, :find).with(@params['id']).
        and_return(@planet)
      @planet.should_receive(:finish_exploration!).with(true)
      invoke @action, @params
    end
  end
  
  describe "planets|remove_foliage" do
    before(:each) do
      player.pure_creds = Cfg.foliage_removal_cost(3, 4)
      player.save!
      @planet = Factory.create(:planet, :player => player)
      @tile = Factory.create(:t_folliage_3x4, :planet => @planet, 
        :x => 3, :y => 4)
      
      @action = "planets|remove_foliage"
      @params = {'id' => @planet.id, 'x' => @tile.x, 'y' => @tile.y}
    end
    
    it_behaves_like "with param options", %w{id x y}
    it_should_behave_like "having controller action scope"
    
    it "should fail if planet does not belong to player" do
      @planet.update_row! ["player_id=?", Factory.create(:player).id]
      
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
    
    it "should invoke #remove_foliage!" do
      SsObject::Planet.stub_chain(:where, :find).with(@planet.id).
        and_return(@planet)
      @planet.should_receive(:remove_foliage!).with(@tile.x, @tile.y)
      invoke @action, @params
    end
    
    it "should work" do
      invoke @action, @params
    end
  end
  
  describe "planets|edit" do
    before(:each) do
      @action = "planets|edit"
      @planet = Factory.create(:planet, :player => player)
      @mothership = Factory.create(:b_mothership, :planet => @planet)
      @params = {'id' => @planet.id, 'name' => "FooPlanet"}
    end

    it_behaves_like "with param options", %w{id}
    it_should_behave_like "having controller action scope"

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

    it "should push changed (with reason owner prop change)" do
      should_fire_event(@planet, EventBroker::CHANGED,
                        EventBroker::REASON_OWNER_PROP_CHANGE) do
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

  describe "planets|boost" do
    before(:each) do
      @planet = Factory.create(:planet, :player => player)
      player.pure_creds = CONFIG['creds.planet.resources.boost.cost']
      player.save!

      @action = "planets|boost"
      @params = {'id' => @planet.id, 'resource' => 'metal',
        'attribute' => 'rate'}
    end

    it_behaves_like "with param options", %w{id resource attribute}
    it_should_behave_like "having controller action scope"

    it "should fail if planet does not belong to you" do
      @planet.player = Factory.create(:player)
      @planet.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
    
    it "should call #boost! on planet" do
      SsObject::Planet.stub_chain(:where, :find).with(@planet.id).
        and_return(@planet)
      @planet.should_receive(:boost!).
        with(@params['resource'], @params['attribute'])
      invoke @action, @params
    end

    it "should work" do
      invoke @action, @params
    end
  end

  describe "planets|portal_units" do
    before(:each) do
      @planet = Factory.create(:planet, :player => player)

      @action = "planets|portal_units"
      @params = {'id' => @planet.id}
    end

    it_behaves_like "with param options", %w{id}
    it_should_behave_like "having controller action scope"

    it "should fail if trying to access not yours planet" do
      planet = Factory.create(:planet)
      lambda do
        invoke @action, @params.merge('id' => planet.id)
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should include unit counts" do
      Building::DefensivePortal.stub!(:portal_unit_counts_for).
        with(@planet).and_return(:counts)
      invoke @action, @params
      response_should_include(:unit_counts => :counts)
    end

    it "should include teleport volume" do
      Building::DefensivePortal.stub!(:teleported_volume_for).
        with(@planet).and_return(:volume)
      invoke @action, @params
      response_should_include(:teleport_volume => :volume)
    end
  end
  
  describe "planets|take" do
    before(:each) do
      @action = "planets|take"
      @planet = Factory.create(:planet)
      @unit = Factory.create(:u_trooper, :location => @planet, 
        :player => player)
      @params = {'id' => @planet.id}
    end
    
    it_behaves_like "with param options", %w{id}
    it_should_behave_like "having controller action scope"

    it "should fail if it's apocalypse" do
      player.galaxy.stub(:apocalypse_started?).and_return(true)

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail if planet does not belong to npc" do
      @planet.player = Factory.create(:player)
      @planet.save!
      
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
    
    it "should fail if you have no units in the planet" do
      @unit.destroy
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end
    
    it "should fail if there are enemy units in the planet" do
      Factory.create(:u_trooper, :location => @planet)
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end
    
    it "should change planet owner" do
      lambda do
        invoke @action, @params
        @planet.reload
      end.should change(@planet, :player).from(nil).to(player)
    end
  end

  describe "planets|bg_spawn" do
    let(:solar_system) { Factory.create(:battleground) }
    let(:alliance) { create_alliance }
    let(:npc_planet) do
      Factory.create(:planet, player: nil, solar_system: solar_system,
        position: 0)
    end
    let(:owner_planet) do
      Factory.create(:planet, player: player, solar_system: solar_system,
        position: 1)
    end
    let(:ally_planet) do
      Factory.create(:planet, player: alliance.owner,
        solar_system: solar_system, position: 1, angle: 90)
    end
    let(:enemy_planet) do
      Factory.create(:planet_with_player, solar_system: solar_system,
        position: 2)
    end
    let(:planet) { owner_planet }

    before(:each) do
      player.alliance = alliance
      player.save!

      @action = 'planets|bg_spawn'
      @params = {'id' => planet.id}
    end

    it "should fail if player doesn't have ground units in the planet" do
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail if your ground units cannot fight" do
      # level 0 unit
      Factory.create(:u_trooper, opts_upgrading + {
        player: player, location: planet, level: 0
      })
      # hidden unit
      Factory.create(:u_trooper, player: player, location: planet,
        hidden: true)
      # Enemy fighting unit
      Factory.create(:u_trooper, player: Factory.create(:player),
        location: planet)
      # NPC fighting unit
      Factory.create(:u_trooper, location: planet)

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    describe "has units" do
      before(:each) do
        # player unit in each type of planet
        [npc_planet, owner_planet, ally_planet, enemy_planet].each do |planet|
          Factory.create(:u_trooper, player: player, location: planet)
        end
      end

      it "should not fail if there are NPC units in planet" do
        Factory.create(:u_trooper, player: nil, location: planet)
        invoke @action, @params
      end

      it "should not fail if there are ally units in planet" do
        Factory.create(:u_trooper, player: alliance.owner, location: planet)
        invoke @action, @params
      end

      it "should fail if there are enemy units in planet" do
        Factory.create(:u_trooper, player: enemy_planet.player,
          location: planet)
        lambda do
          invoke @action, @params
        end.should raise_error(GameLogicError)
      end

      it "should fail if there are nap units in planet"

      it "should fail if planet belongs to enemy" do
        lambda do
          invoke @action, @params.merge('id' => enemy_planet.id)
        end.should raise_error(GameLogicError)
      end

      it "should fail if planet belongs to nap"

      it "should pass if planet belongs to ally" do
        invoke @action, @params.merge('id' => ally_planet.id)
      end

      it "should pass if planet belongs to current player" do
        lambda do
          invoke @action, @params.merge('id' => owner_planet.id)
        end.should_not raise_error
      end

      it "should pass if planet belongs to NPC" do
        lambda do
          invoke @action, @params.merge('id' => npc_planet.id)
        end.should_not raise_error
      end

      it "should create notification if its an ally planet" do
        Notification.should_receive(:create_for_ally_planet_boss_spawn).
          with(ally_planet, player)
        invoke @action, @params.merge('id' => ally_planet.id)
      end

      it "should not create notification if its your planet" do
        Notification.should_not_receive(:create_for_ally_planet_boss_spawn)
        invoke @action, @params.merge('id' => owner_planet.id)
      end

      it "should not create notification if its a NPC planet" do
        Notification.should_not_receive(:create_for_ally_planet_boss_spawn)
        invoke @action, @params.merge('id' => npc_planet.id)
      end

      it "should call spawn" do
        SsObject::Planet.should_receive(:find).with(owner_planet.id).
          and_return(owner_planet)
        owner_planet.should_receive(:spawn_boss!)

        invoke @action, @params
      end

      it "should work" do
        invoke @action, @params
      end
    end
  end

  describe "planets|reinitiate_combat" do
    let(:owned_planet) { prepared Factory.create(:planet, player: player) }
    let(:enemy_planet) { prepared Factory.create(:planet_with_player) }
    let(:npc_planet) { prepared Factory.create(:planet) }
    let(:alliance) { create_alliance }
    let(:ally) { Factory.create(:player, alliance: alliance) }
    let(:ally_planet) do
      player.alliance = alliance
      player.save!
      prepared Factory.create(:planet, player: ally)
    end
    let(:planet) { owned_planet }

    def with_your_unit(planet)
      @your_unit = Factory.create(:u_gnat, location: planet, player: player)
      planet
    end
    # Non-combat your unit
    def with_nc_your_unit(planet)
      @nc_your_unit = Factory.create!(:u_mdh, location: planet, player: player)
      planet
    end
    def with_npc_unit(planet)
      @npc_unit = Factory.create(:u_gnat, location: planet, player: nil)
      planet
    end
    # Non-combat NPC unit
    def with_nc_npc_unit(planet)
      @nc_npc_unit = Factory.create!(:u_mdh, location: planet, player: nil)
      planet
    end
    def prepared(planet)
      with_your_unit(with_npc_unit(planet))
    end

    before(:each) do
      @action = "planets|reinitiate_combat"
      @params = {'id' => planet.id}
    end

    it "should pass if planet is owned by player" do
      invoke @action, @params.merge('id' => owned_planet.id)
    end

    it "should pass if planet is owned by npc" do
      invoke @action, @params.merge('id' => npc_planet.id)
    end

    it "should pass if planet is owned by ally" do
      invoke @action, @params.merge('id' => ally_planet.id)
    end

    it "should fail if planet is owned by enemy" do
      lambda do
        invoke @action, @params.merge('id' => enemy_planet.id)
      end.should raise_error(GameLogicError)
    end

    it "should fail if planet is owned by nap"

    it "should fail if planet doesn't have at least one NPC unit" do
      planet
      @npc_unit.destroy!
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    describe "if there are no player combat units" do
      it "should pass if planet is owned by player" do
        owned_planet; @your_unit.destroy!
        invoke @action, @params.merge('id' => owned_planet.id)
      end

      it "should fail if planet is owned by npc" do
        npc_planet; @your_unit.destroy!
        lambda do
          invoke @action, @params.merge('id' => npc_planet.id)
        end.should raise_error(GameLogicError)
      end

      it "should fail if planet is owned by ally" do
        ally_planet; @your_unit.destroy!
        lambda do
          invoke @action, @params.merge('id' => ally_planet.id)
        end.should raise_error(GameLogicError)
      end
    end

    describe "if there are player combat units" do
      it "should pass if planet is owned by player" do
        invoke @action, @params.merge('id' => owned_planet.id)
      end

      it "should pass if planet is owned by npc" do
        invoke @action, @params.merge('id' => npc_planet.id)
      end

      it "should pass if planet is owned by ally" do
        invoke @action, @params.merge('id' => ally_planet.id)
      end
    end

    it "should fail if there are enemy units in planet" do
      Factory.create(:u_gnat, player: Factory.create(:player), location: planet)
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail if there are nap units in planet"

    it "should not create notification if its your planet" do
      Notification.should_not_receive(:create_for_ally_planet_reinitiate_combat)
      invoke @action, @params.merge('id' => owned_planet.id)
    end

    it "should not create notification if its a NPC planet" do
      Notification.should_not_receive(:create_for_ally_planet_reinitiate_combat)
      invoke @action, @params.merge('id' => npc_planet.id)
    end

    it "should create notification if its an ally planet" do
      Notification.should_receive(:create_for_ally_planet_reinitiate_combat).
        with(ally_planet, player)
      invoke @action, @params.merge('id' => ally_planet.id)
    end

    it "should check planet for conflicts ignoring cooldowns" do
      Combat::LocationChecker.should_receive(:check_location).with(
        planet.location_point, check_for_cooldown: false
      )
      invoke @action, @params
    end
  end
end