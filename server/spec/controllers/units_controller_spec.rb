require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

shared_examples_for "checking visibility" do
  it "should raise GameLogicError if target is not visible" do
    @fge.destroy
    lambda do
      invoke @action, @params
    end.should raise_error(GameLogicError)
  end
end

def uc_create_alliance(player)
  if player.alliance.nil?
    player.alliance = Factory.create(:alliance)
    player.save!
  end

  ally = Factory.create(:player, :alliance => player.alliance)
  [ally, player.alliance]
end

def uc_create_nap(player)
  if player.alliance.nil?
    player.alliance = Factory.create(:alliance)
    player.save!
  end

  nap_alliance = Factory.create(:alliance)
  Factory.create(:nap, :initiator => player.alliance,
    :acceptor => nap_alliance)

  nap = Factory.create(:player, :alliance => nap_alliance)

  [nap, player.alliance, nap_alliance]
end

shared_examples_for "checking all planet owner variations" do |wanted_results|
  [
    ["ally", lambda do |player, planet|
      ally, alliance = uc_create_alliance(player)
      planet.update_row! ["player_id=?", ally.id]
    end],
    ["nap", lambda do |player, planet|
      nap, alliance, nap_alliance = uc_create_nap(player)
      planet.update_row! ["player_id=?", nap.id]
    end],
    ["enemy", lambda do |player, planet|
      planet.update_row! ["player_id=?", Factory.create(:player).id]
    end],
    ["you", lambda do |player, planet|
      planet.update_row! ["player_id=?", player.id]
    end],
    ["no one", lambda do |player, planet|
      planet.update_row! ["player_id=?", nil]
    end],
  ].each do |name, runnable|
    raise ArgumentError.
      new("wanted_results does not have key #{name.inspect}") \
      unless wanted_results.has_key?(name)

    should_fail = wanted_results[name]
    fail_name = should_fail ? "fail" : "not fail"
    it "should #{fail_name} if planet belongs to #{name}" do
      fail_method = should_fail ? :should : :should_not
      runnable.call player, @planet
      lambda do
        invoke @action, @params
      end.send(fail_method, raise_error(GameLogicError))
    end
  end
end

describe UnitsController do
  include ControllerSpecHelper

  before(:each) do
    init_controller UnitsController, :login => true
  end

  describe "units|new" do
    before(:each) do
      @action = "units|new"
      @planet = Factory.create :planet, :player => player
      @constructor = Factory.create :b_constructor_test, :planet => @planet

      set_resources(@planet, 10000, 10000, 10000)

      @params = {
        'type' => 'TestUnit',
        'count' => 1,
        'constructor_id' => @constructor.id,
        'prepaid' => true
      }
    end

    it_behaves_like "with param options", %w{type count constructor_id prepaid}
    it_should_behave_like "having controller action scope"

    it "should fail if not prepaid and player is not vip" do
      @params['prepaid'] = false
      player.stub(:vip?).and_return(false)

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should not have any reply" do
      invoke @action, @params
      @controller.response_params.should be_blank
    end
    
    it "should check constructors owner" do
      @planet.player = nil
      @planet.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should invoke #construct! on constructor" do
      Building.should_receive(:find).
        with(@constructor.id, an_instance_of(Hash)).and_return(@constructor)
      @constructor.should_receive(:construct!).with(
        "Unit::#{@params['type']}", @params['prepaid'],
        {}, @params['count'].to_i
      )
      invoke @action, @params
    end
  end

  describe "units|update" do
    before(:each) do
      @action = "units|update"
      @updates = {
        1 => [1, Combat::STANCE_AGGRESSIVE],
        2 => [0, Combat::STANCE_AGGRESSIVE],
        3 => [1, Combat::STANCE_AGGRESSIVE]
      }
      # JSON hashes must have keys as strings.
      @params = {'updates' => @updates.map_keys { |k, v| k.to_s }}
    end

    it_behaves_like "with param options", %w{updates}
    it_should_behave_like "having controller action scope"

    it "should call Unit.update_combat_attributes" do
      Unit.should_receive(:update_combat_attributes).with(
        player.id, @updates
      )
      invoke @action, @params
    end
  end

  describe "units|set_hidden" do
    before(:each) do
      @action = "units|set_hidden"
      @params = {
        'planet_id' => 5598, 'unit_ids' => [12, 13, 14], 'value' => true
      }
    end

    it_behaves_like "with param options", %w{planet_id unit_ids value}
    it_should_behave_like "having controller action scope"

    it "should call Unit.mass_set_hidden" do
      Unit.should_receive(:mass_set_hidden).with(
        player.id, @params['planet_id'], @params['unit_ids'], @params['value']
      )
      invoke @action, @params
    end
  end

  describe "units|attack" do
    before(:each) do
      @action = "units|attack"

      @planet = Factory.create :planet, :player => player
      @target = Factory.create :b_npc_solar_plant, :planet => @planet
      @target_units = [
        Factory.create(:u_gnat, :player => nil,
          :location => @target, :level => 1, :hp_percentage => 0.2),
        Factory.create(:u_gnat, :player => nil,
          :location => @target, :level => 1, :hp_percentage => 0.2)
      ]

      # Ensure our side wins so we could test outcomes for ally attack
      # notifications.
      @units = [
        Factory.create(:u_trooper, :player => player,
          :location => @planet, :level => 1, :hp_percentage => 1),
        Factory.create(:u_trooper, :player => player,
          :location => @planet, :level => 1, :hp_percentage => 1),
      ]
      @params = {
        'planet_id' => @planet.id,
        'target_id' => @target.id,
        'unit_ids' => @units.map(&:id)
      }
    end

    it_should_behave_like "with param options",
                          %w{planet_id target_id unit_ids}
    it_should_behave_like "having controller action scope"

    def set_ally
      player.alliance = create_alliance; player.save!
      @planet.update_row! player_id: player.alliance.owner_id
      @ally = player.alliance.owner
    end

    it "should raise RecordNotFound if it's not that player planet" do
      @planet.player = Factory.create(:player)
      @planet.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should not raise RecordNotFound if it's ally planet" do
      set_ally
      invoke @action, @params
    end

    it "should raise RecordNotFound if the target is not npc" do
      with_config_values 'buildings.npc_solar_plant.npc' => false do
        lambda do
          invoke @action, @params
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it "should raise error if units are empty" do
      lambda do
        invoke @action, @params.merge('unit_ids' => [])
      end.should raise_error(GameLogicError)
    end

    it "should raise error if some units are not in that planet" do
      @units[0].location = Factory.create(:planet)
      @units[0].save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should raise error if some units does not belong to that player" do
      @units[0].player = Factory.create(:player)
      @units[0].save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should not create cooldown" do
      invoke @action, @params
      Cooldown.where(:location_ss_object_id => @planet.id).should_not exist
    end

    it "should not push notification to player" do
      should_not_fire_event(
        an_instance_of(Notification), EventBroker::CREATED
      ) do
        invoke @action, @params
      end
    end

    it "should not push notification to player, but push to ally" do
      set_ally
      SPEC_EVENT_HANDLER.clear_events!
      invoke @action, @params
      # No pushed notification for player
      SPEC_EVENT_HANDLER.events.any? do |(object, *_), event, reason|
        object.is_a?(Notification) && event == EventBroker::CREATED &&
        object.player_id == player.id
      end.should be_false
      # Pushed notification for ally
      SPEC_EVENT_HANDLER.events.any? do |(object, *_), event, reason|
        object.is_a?(Notification) && event == EventBroker::CREATED &&
        object.player_id == @planet.player_id
      end.should be_true
    end

    it "should have same outcome in ally and attacker notifications" do
      set_ally
      invoke @action, @params
      Notification.where(player_id: player.id).last.params['outcome'].should ==
        Notification.where(player_id: @ally.id).last.params['outcome']
    end

    it "should respond with the notification" do
      invoke @action, @params
      response_should_include(
        notification: Notification.where(player_id: player.id).last.as_json
      )
    end

    describe "when all units are killed" do
      before(:each) do
        @target_units.each(&:destroy)
        Factory.create(:u_gnat, :player => nil,
          :location => @target, :level => 1, :hp => 1)
      end

      it "should destroy building" do
        invoke @action, @params
        lambda do
          @target.reload
        end.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should progress objective" do
        Objective::DestroyNpcBuilding.should_receive(:progress).with(
          @target, player
        )
        invoke @action, @params
      end
    end
  end

  describe "units|move_meta" do
    before(:each) do
      @action = "units|move_meta"
      @unit_ids = [1, 2, 3]
      @source = SolarSystemPoint.new(10, 1, 0)
      solar_system = Factory.create(:solar_system, galaxy: player.galaxy)
      @target = SolarSystemPoint.new(solar_system.id, 1, 0)
      @fge = fge_around(solar_system, player: player)
      @jg = Factory.create(:sso_jumpgate)
      @params = {
        'unit_ids' => @unit_ids,
        'source' => {
          'location_id' => @source.id,
          'location_type' => @source.type,
          'location_x' => @source.x,
          'location_y' => @source.y
        },
        'target' => {
          'location_id' => @target.id,
          'location_type' => @target.type,
          'location_x' => @target.x,
          'location_y' => @target.y
        },
        'avoid_npc' => true
      }
    end

    it_behaves_like "with param options", %w{unit_ids source target}
    it_behaves_like "checking visibility"
    it_should_behave_like "having controller action scope"

    it "should invoke UnitMover" do
      UnitMover.should_receive(:move_meta).with(
        player.id, @unit_ids, @source, @target, @params['avoid_npc']
      ).and_return([20.minutes.from_now, 20])
      invoke @action, @params
    end

    it "should return arrival date" do
      date = 20.minutes.from_now
      UnitMover.should_receive(:move_meta).with(
        player.id, @unit_ids, @source, @target, @params['avoid_npc']
      ).and_return([date, 10])
      invoke @action, @params
      response_should_include(:arrival_date => date)
    end
    
    it "should return hop count" do
      UnitMover.should_receive(:move_meta).with(player.id, @unit_ids,
        @source, @target, @params['avoid_npc']
      ).and_return([20.minutes.from_now, 10])
      invoke @action, @params
      response_should_include(:hop_count => 10)
    end
  end

  describe "units|move" do
    before(:each) do
      @action = "units|move"
      source_ss = Factory.create(:solar_system, galaxy: player.galaxy, x: 1)
      Factory.create(:sso_jumpgate, solar_system: source_ss, position: 3)
      target_ss = Factory.create(:solar_system, galaxy: player.galaxy)
      Factory.create(:sso_jumpgate, solar_system: target_ss, position: 3)
      @source = SolarSystemPoint.new(source_ss.id, 1, 0)
      @target = SolarSystemPoint.new(target_ss.id, 3, 180)
      
      units = [
        Factory.create(:u_crow, :player => player, :location => @source),
        Factory.create(:u_crow, :player => player, :location => @source),
        Factory.create(:u_crow, :player => player, :location => @source),
      ]
      @unit_ids = units.map(&:id)
      @fge = fge_around(target_ss, player: player)
      @params = {
        'unit_ids' => @unit_ids,
        'source' => {
          'location_id' => @source.id,
          'location_type' => @source.type,
          'location_x' => @source.x,
          'location_y' => @source.y
        },
        'target' => {
          'location_id' => @target.id,
          'location_type' => @target.type,
          'location_x' => @target.x,
          'location_y' => @target.y
        },
        'avoid_npc' => true,
        'speed_modifier' => 1.1
      }
    end

    it_behaves_like "with param options",
      %w{unit_ids source target speed_modifier}
    it_behaves_like "checking visibility"
    it_should_behave_like "having controller action scope"

    it "should invoke UnitMover" do
      UnitMover.should_receive(:move).with(player.id, @unit_ids, @source,
        @target, @params['avoid_npc'], @params['speed_modifier']
      ).and_return(Factory.create(:route))
      invoke @action, @params
    end
    
    it "should create speed modifier object" do
      modifier = MoveSpeedModifier.new(@params['speed_modifier'])
      MoveSpeedModifier.should_receive(:new).
        with(@params['speed_modifier']).and_return(modifier)
      invoke @action, @params
    end
    
    it "should call #deduct_creds! on that" do
      modifier = MoveSpeedModifier.new(@params['speed_modifier'])
      MoveSpeedModifier.stub!(:new).
        with(@params['speed_modifier']).and_return(modifier)
      modifier.should_receive(:deduct_creds!).with(player, 
        @params['unit_ids'], @source, @target, @params['avoid_npc'])
      invoke @action, @params
    end
    
    it "should not return anything" do
      route = Factory.create(:route)
      UnitMover.should_receive(:move).and_return(route)
      @controller.should_not_receive(:respond)
      invoke @action, @params
    end

    it "should work" do
      invoke @action, @params
    end
  end

  describe "units|movement_prepare" do
    before(:each) do
      @action = "units|movement_prepare"
      @params = {'route' => {:route => 'fake'}, 'unit_ids' => [:unit_ids],
        'route_hops' => [:route_hops]}
      @method = :push
    end

    it_behaves_like "with param options",
      :required => %w{route unit_ids route_hops},
      :only_push => true
    it_should_behave_like "having controller action scope"
  end

  describe "units|movement" do
    before(:each) do
      @action = "units|movement"
      @params = {
        'units' => [
          Factory.create!(:u_dart),
          Factory.create!(:u_dart),
        ],
        'route_hops' => [:route_hops],
        'jumps_at' => 5.minutes.from_now
      }
      @method = :push
    end

    it_behaves_like "with param options",
      :required => %w{units route_hops jumps_at},
      :only_push => true
    it_should_behave_like "having controller action scope"

    it "should respond with units with perspective" do
      push @action, @params
      resolver = StatusResolver.new(player)
      response_should_include(:units =>
          @params['units'].map {
            |unit| unit.as_json(:perspective => resolver) }
      )
    end

    it "should respond with players" do
      push @action, @params
      response_should_include(
        :players => Player.minimal_from_objects(@params['units'])
      )
    end

    it "should respond with route_hops" do
      push @action, @params
      response_should_include(:route_hops => @params['route_hops'])
    end

    it "should respond with jumps_at" do
      push @action, @params
      response_should_include(:jumps_at => @params['jumps_at'])
    end
  end

  describe "units|deploy" do
    before(:each) do
      @action = "units|deploy"
      @planet = Factory.create(:planet, :player => player)
      @unit = Factory.create(:u_deployable_test, :player => player,
        :location => @planet)
      @params = {'planet_id' => @planet.id, 'unit_id' => @unit.id,
        'x' => 0, 'y' => 0}
    end

    it_behaves_like "with param options", %w{planet_id unit_id x y}
    it_should_behave_like "having controller action scope"

    it "should not fail if unit is in another unit in same planet" do
      @unit.location = Factory.create(:unit, :location => @planet)
      @unit.save!

      lambda do
        invoke @action, @params
      end.should_not raise_error(ActiveRecord::RecordNotFound)
    end

    it "should not fail if player is deploying to alliance planet" do
      alliance = create_alliance
      player.alliance = alliance
      player.save!
      @planet.update_row! :player_id => alliance.owner_id

      lambda do
        invoke @action, @params
      end.should_not raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if player doesn't own that planet" do
      # To prevent unit ownership transfer.
      @planet.update_row! player_id: nil

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if player doesn't own that unit" do
      @unit.player = nil
      @unit.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if unit is not in same planet" do
      @unit.location = Factory.create(:planet)
      @unit.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if unit is in another unit but it's not in " +
    "same planet" do
      @unit.location = Factory.create(:unit)
      @unit.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should deploy unit" do
      Unit.stub_chain(:where, :find).and_return(@unit)
      @unit.should_receive(:deploy).with(@planet, 
        @params['x'], @params['y'])
      invoke @action, @params
    end

    it "should mark as handled" do
      invoke(@action, @params).should be_true
    end
  end

  describe "units|load" do
    before(:each) do
      @action = "units|load"
      @planet = Factory.create(:planet)
      @transporters = [
        Factory.create(:u_with_storage, location: @planet, player: player),
        Factory.create(:u_with_storage, location: @planet, player: player),
      ]
      @t1_units = [
        Factory.create(:u_loadable_test, location: @planet, player: player),
        Factory.create(:u_loadable_test, location: @planet, player: player),
      ]
      @t2_units = [
        Factory.create(:u_loadable_test, location: @planet, player: player),
      ]
      @units = @t1_units + @t2_units
      @params = {
        'unit_ids' => {
          @transporters[0].id.to_s => @t1_units.map(&:id),
          @transporters[1].id.to_s => @t2_units.map(&:id),
        }
      }
      player.vip_level = 1
    end

    it_behaves_like "with param options", %w{unit_ids}
    it_should_behave_like "having controller action scope"
    
    it_should_behave_like "checking all planet owner variations",
        {"you" => false, "no one" => false, "enemy" => false, "ally" => false,
         "nap" => false}

    describe "if player is not a vip" do
      before(:each) do
        player.vip_level = 0
      end

      it "should fail if player is not vip" do
        lambda do
          invoke @action, @params
        end.should raise_error(GameLogicError)
      end

      it "should not fail if only 1 transporter is used" do
        @params['unit_ids'].delete(@transporters[0].id.to_s)
        invoke @action, @params
      end
    end

    it "should fail if no transporters are used" do
      lambda do
        invoke @action, @params.merge('unit_ids' => {})
      end.should raise_error(GameLogicError)
    end

    it "should fail if transporters are not in same location" do
      planet = Factory.create(:planet)
      @transporters[1].location = planet
      @transporters[1].save!
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail if any of the transporters does not belong to player" do
      @transporters[0].player = Factory.create(:player)
      @transporters[0].save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if any of the units does not belong to player" do
      @units[0].player = Factory.create(:player)
      @units[0].save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should move units" do
      invoke @action, @params
      @units.each(&:reload)
      @units.map(&:location).should == (
        [@transporters[0].location_point] * @t1_units.size
      ) + (
        [@transporters[1].location_point] * @t2_units.size
      )
    end
  end

  describe "units|unload" do
    before(:each) do
      @action = "units|unload"
      @planet = Factory.create(:planet, :player => player)
      @transporters = [
        Factory.create(:u_with_storage, location: @planet, player: player),
        Factory.create(:u_with_storage, location: @planet, player: player),
      ]
      @t1_units = [
        Factory.create(:u_loadable_test, location: @transporters[0],
          player: player),
        Factory.create(:u_loadable_test, location: @transporters[0],
          player: player),
      ]
      @t2_units = [
        Factory.create(:u_loadable_test, location: @transporters[1],
          player: player),
        Factory.create(:u_loadable_test, location: @transporters[1],
          player: player),
      ]
      @units = @t1_units + @t2_units
      @params = {
        'unit_ids' => {
          @transporters[0].id.to_s => @t1_units.map(&:id),
          @transporters[1].id.to_s => @t2_units.map(&:id),
        }
      }
      player.vip_level = 1
    end

    it_behaves_like "with param options", %w{unit_ids}
    it_should_behave_like "having controller action scope"

    it_should_behave_like "checking all planet owner variations",
        {"you" => false, "no one" => false, "enemy" => false, "ally" => false,
         "nap" => false}

    describe "if player is not a vip" do
      before(:each) do
        player.vip_level = 0
      end

      it "should fail if player is not vip" do
        lambda do
          invoke @action, @params
        end.should raise_error(GameLogicError)
      end

      it "should not fail if only 1 transporter is used" do
        @params['unit_ids'].delete(@transporters[0].id.to_s)
        invoke @action, @params
      end
    end

    it "should fail if no transporters are used" do
      lambda do
        invoke @action, @params.merge('unit_ids' => {})
      end.should raise_error(GameLogicError)
    end

    it "should fail if transporters are not in same location" do
      planet = Factory.create(:planet, player: player)
      @transporters[1].location = planet
      @transporters[1].save!
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail if some of the units are not found" do
      @units[0].destroy
      
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail when unloading 1 unit and it cannot be found" do
      # This was an actual bug, where Unit.first.units.find([non_existant_id])
      # returned [nil]...
      @units[0].destroy
      @params['unit_ids'][@transporters[0].id.to_s].pop

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if any transporter does not belong to player" do
      @transporters[0].player = Factory.create(:player)
      @transporters[0].save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if any transporter is not in planet" do
      @transporters[0].location = @planet.solar_system_point
      @transporters[0].save!

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end
    
    it "should not fail if planet belongs to enemy" do
      @planet.update_row! ["player_id=?", Factory.create(:player).id]

      lambda do
        invoke @action, @params
      end.should_not raise_error(GameLogicError)
    end
    
    it "should not fail if planet belongs to self" do
      lambda do
        invoke @action, @params
      end.should_not raise_error(GameLogicError)
    end
    
    it "should not fail if planet belongs to ally" do
      ally, alliance = uc_create_alliance(player)

      @planet.update_row! ["player_id=?", ally.id]

      lambda do
        invoke @action, @params
      end.should_not raise_error(GameLogicError)
    end

    it "should not fail if planet belongs to nap" do
      nap, alliance, nap_alliance = uc_create_nap(player)

      @planet.update_row! ["player_id=?", nap.id]

      lambda do
        invoke @action, @params
      end.should_not raise_error(GameLogicError)
    end

    it "should move units" do
      invoke @action, @params
      @units.each(&:reload)
      @units.map(&:location).should == [@planet.location_point] * @units.size
    end
  end

  describe "units|transfer_resources" do
    before(:each) do
      @action = "units|transfer_resources"
      @planet = Factory.create(:planet, :player => player)
      set_resources(@planet, 100, 100, 100, 200, 200, 200)
      @transporters = [
        Factory.create(:u_with_storage, location: @planet, player: player),
        Factory.create(:u_with_storage, location: @planet, player: player),
      ]
      @params = {
        'transporters' => {
          @transporters[0].id.to_s => {
            'metal' => 10, 'energy' => 10, 'zetium' => 10
          },
          @transporters[1].id.to_s => {
            'metal' => 15, 'energy' => 20, 'zetium' => 20
          }
        }
      }
      player.vip_level = 1
    end

    def stub_transporters
      Unit.stub_chain(:where, :find).with(@transporters.map(&:id)).
        and_return(@transporters)
    end

    def setup_call_expectations
      stub_transporters
      @transporters.each do |transporter|
        transporter.should_receive(:transfer_resources!).with(
          @params["transporters"][transporter.id.to_s]['metal'],
          @params["transporters"][transporter.id.to_s]['energy'],
          @params["transporters"][transporter.id.to_s]['zetium']
        )
      end
    end

    it_behaves_like "with param options", %w{transporters}
    it_should_behave_like "having controller action scope"

    describe "loading" do
      it_should_behave_like "checking all planet owner variations",
        {"you" => false, "no one" => false, "enemy" => true, "ally" => true,
         "nap" => true}
    end

    describe "unloading" do
      before(:each) do
        @transporters.each do |transporter|
          transporter.metal = transporter.energy = transporter.zetium = 100
          transporter.stored = Resources.total_volume(
            transporter.metal, transporter.energy, transporter.zetium
          )
          transporter.save!
        end
        @params = {
          'transporters' => {
            @transporters[0].id.to_s => {
              'metal' => -10, 'energy' => -10, 'zetium' => -10
            },
            @transporters[1].id.to_s => {
              'metal' => -15, 'energy' => -20, 'zetium' => -25
            }
          }
        }
      end

      it_should_behave_like "checking all planet owner variations",
        {"you" => false, "no one" => false, "enemy" => false, "ally" => false,
         "nap" => false}

      it "should not fail if planet has no storage" do
        set_resources(@planet, 100, 100, 100)
        invoke @action, @params
        response_should_include(:kept_resources => {
          metal: 25, energy: 30, zetium: 35
        })
      end

      it "should respond with kept resources hash" do
        invoke @action, @params
        response_should_include(
          :kept_resources => {:metal => 0, :energy => 0, :zetium => 0}
        )
      end

      describe "when unloading more resources than planet can hold" do
        before(:each) do
          set_resources(@planet, 100, 100, 100, 104, 105, 106)
        end

        it "should keep resources that don't fit in transporter" do
          invoke @action, @params
          @transporters.map do |transporter|
            transporter.reload
            Resources::TYPES.map do |resource|
              transporter.send(resource)
            end
          end.should == [[96, 95, 94], [100, 100, 100]]
        end

        it "should invoke unload with adjusted values" do
          stub_transporters
          @transporters[0].should_receive(:transfer_resources!).with(-4, -5, -6)
          @transporters[1].should_not_receive(:transfer_resources!)
          invoke @action, @params
        end

        it "should unload ints if planet has float storage" do
          set_resources(@planet, 100, 100, 100, 104.3, 105.2, 106.1)

          stub_transporters
          @transporters[0].should_receive(:transfer_resources!).with(-4, -5, -6)
          @transporters[1].should_not_receive(:transfer_resources!)
          invoke @action, @params
        end

        it "should respond with kept resources hash" do
          invoke @action, @params
          response_should_include(:kept_resources => {
            metal: 6 + 15, energy: 5 + 20, zetium: 4 + 25
          })
        end

        it "should use planet storage with modifiers" do
          [:t_metal_storage, :t_energy_storage, :t_zetium_storage].each do |t|
            Factory.create!(t, :player => @planet.player, :level => 1)
          end

          invoke @action, @params
          response[:kept_resources][:metal].should < 6
          response[:kept_resources][:energy].should < 5
          response[:kept_resources][:zetium].should < 4
        end
      end
    end

    describe "if player is not a vip" do
      before(:each) do
        player.vip_level = 0
      end

      it "should fail if player is not vip" do
        lambda do
          invoke @action, @params
        end.should raise_error(GameLogicError)
      end

      it "should not fail if only 1 transporter is used" do
        @params['transporters'].delete(@transporters[0].id.to_s)
        invoke @action, @params
      end
    end

    it "should fail if no transporters are used" do
      lambda do
        invoke @action, @params.merge('transporters' => {})
      end.should raise_error(GameLogicError)
    end

    it "should fail if transporters are not in same location" do
      planet = Factory.create(:planet, player: player)
      @transporters[1].location = planet
      @transporters[1].save!
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should raise error if any transporter does not belong to player" do
      @transporters[1].player = Factory.create(:player)
      @transporters[1].save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should raise error if you're not trying to do anything" do
      nothing = {'metal' => 0, 'energy' => 0, 'zetium' => 0}
      lambda do
        invoke @action, {
          'transporters' => {
            @transporters[0].id.to_s => nothing,
            @transporters[1].id.to_s => nothing
          }
        }
      end.should raise_error(GameLogicError)
    end

    it "should call #transfer_resources! on transporter" do
      setup_call_expectations
      invoke @action, @params
    end

    it "should call #transfer_resources! on transporter (with wreckage)" do
      @transporters.each do |transporter|
        transporter.location = @planet.solar_system_point
        transporter.save!
      end

      Factory.create(:wreckage, :location => @planet.solar_system_point)

      setup_call_expectations
      invoke @action, @params
    end

    it "should just work" do
      invoke @action, @params
    end
  end

  describe "units|show" do
    before(:each) do
      @action = "units|show"
      @transporters = [
        Factory.create(:u_with_storage, :player => player),
        Factory.create(:u_with_storage, :player => player),
      ]
      @t1_units = [
        Factory.create(:u_loadable_test, :location => @transporters[0]),
        Factory.create(:u_loadable_test, :location => @transporters[0]),
      ]
      @t2_units = [
        Factory.create(:u_loadable_test, :location => @transporters[1]),
      ]
      @units = @t1_units + @t2_units
      @params = {'unit_ids' => @transporters.map(&:id)}
      player.vip_level = 1
    end

    it_behaves_like "with param options", %w{unit_ids}
    it_should_behave_like "having controller action scope"

    it "should not work if any transporter belongs to ally" do
      player.alliance = Factory.create(:alliance)
      player.save!

      @transporters[0].player = Factory.create(
        :player, :alliance => player.alliance
      )
      @transporters[0].save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should raise not found if any transporter doesn't belong to player" do
      @transporters[1].player = Factory.create(:player)
      @transporters[1].save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should return units" do
      invoke @action, @params
      response_should_include(:units => @units.map(&:as_json))
    end

    describe "non-vip" do
      before(:each) do
        player.vip_level = 0
      end

      it "should fail if trying to view several transporters" do
        lambda do
          invoke @action, @params
        end.should raise_error(GameLogicError)
      end

      it "should not fail if trying to view one transporter" do
        invoke @action, @params.merge('unit_ids' => [@transporters[0].id])
        response_should_include(:units => @t1_units.map(&:as_json))
      end
    end
  end

  describe "units|heal" do
    before(:each) do
      @planet = Factory.create(:planet, :player => player)
      set_resources(@planet, 100000, 100000, 100000)
      @hp_diff = Unit::Crow.hit_points / 2
      @unit = Factory.create(:u_crow, :level => 1,
        :hp => @hp_diff, :location => @planet)
      @building = Factory.create!(:b_healing_center, :planet => @planet,
        :level => 1, :state => Building::STATE_ACTIVE)

      @action = "units|heal"
      @params = {'building_id' => @building.id, 'unit_ids' => [@unit.id]}
    end

    it "should invoke fine" do
      invoke @action, @params
    end
    
    it "should fail in alliance planet" do
      ally, alliance = uc_create_alliance(player)
      @planet.player = ally; @planet.save!
      
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail in nap planet" do
      nap, nap_alliance = uc_create_nap(player)
      @planet.player = nap; @planet.save!

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail in enemy planet" do
      @planet.player = Factory.create(:player); @planet.save!

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end
    
    it "should raise error if there is no healing center" do
      @building.destroy
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should call heal on building" do
      Building.stub!(:find).with(@building.id).and_return(@building)
      @building.should_receive(:heal!).with([@unit])
      invoke @action, @params
    end
  end

  describe "units|dismiss" do
    before(:each) do
      @planet = Factory.create(:planet, :player => player)
      @units = [
        Factory.create(:u_gnat, :player => player, :location => @planet),
        Factory.create(:u_trooper, :player => player, :location => @planet),
      ]

      @action = "units|dismiss"
      @params = {'planet_id' => @planet.id, 'unit_ids' => @units.map(&:id)}
    end

    it_behaves_like "with param options", %w{planet_id unit_ids}
    it_should_behave_like "having controller action scope"

    it "should fail if planet does not belong to player" do
      @planet.player = Factory.create(:player)
      @planet.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should call Unit.dismiss_units" do
      Unit.should_receive(:dismiss_units).with(@planet, @units.map(&:id))
      invoke @action, @params
    end

    it "should pass without errors" do
      invoke @action, @params
    end
  end

  describe "units|positions" do
    before(:each) do
      @action = "units|positions"
      @params = {}
      
      alliance = Factory.create(:alliance, :owner => player)
      player.alliance = alliance
      player.save!
      ally = Factory.create(:player, :alliance => alliance)

      @units = [
        Factory.create!(:u_trooper, :player => player),
        Factory.create!(:u_shocker, :player => ally),
      ]
    end

    it "should include positions for friendly units" do
      invoke @action, @params
      response_should_include(
        :positions => Unit.positions(Unit.where(:id => @units.map(&:id)))
      )
    end

    it "should not include moving units" do
      @units.each do |unit|
        unit.route = Factory.create(:route, :player => player)
        unit.save!
      end
      
      invoke @action, @params
      response[:positions].should be_blank
    end

    it "should not include positions for loaded units" do
      @units.each(&:destroy)
      
      mule = Factory.create(:u_mule, :player => player,
                            :route => Factory.create(:route))
      Factory.create(:u_trooper, :player => player, :location => mule)
      invoke @action, @params
      response[:positions].should be_blank
    end

    it "should not include positions for units whose level == 0" do
      @units.each do |unit|
        unit.level = 0
        unit.save!
      end

      invoke @action, @params
      response[:positions].should be_blank
    end

    it "should include players for those units" do
      invoke @action, @params
      response_should_include(
        :players => Player.minimal_from_objects(@units)
      )
    end
  end
end