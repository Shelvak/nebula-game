require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

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
        'constructor_id' => @constructor.id
      }
    end

    @required_params = %w{type count constructor_id}
    it_should_behave_like "with param options"

    it "should not reply" do
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
  end

  describe "units|update" do
    before(:each) do
      @action = "units|update"
      @updates = {
        1 => [1, Combat::STANCE_AGGRESSIVE],
        2 => [0, Combat::STANCE_AGGRESSIVE],
        3 => [1, Combat::STANCE_AGGRESSIVE]
      }
      @params = {'updates' => @updates}
    end

    @required_params = %w{updates}
    it_should_behave_like "with param options"

    it "should update flanks" do
      Unit.should_receive(:update_combat_attributes).with(
        player.id, @updates
      )
      invoke @action, @params
    end
  end

  describe "units|attack" do
    describe "invoked" do
      before(:each) do
        @action = "units|attack"

        @planet = Factory.create :planet, :player => player
        @target = Factory.create :b_npc_solar_plant, :planet => @planet
        @target_units = [
          Factory.create(:u_gnat, :player => nil,
            :location => @target, :level => 1, :hp => 80),
          Factory.create(:u_gnat, :player => nil,
            :location => @target, :level => 1, :hp => 80)
        ]

        @units = [
          Factory.create(:u_trooper, :player => player,
            :location => @planet, :level => 1, :hp => 20),
          Factory.create(:u_trooper, :player => player,
            :location => @planet, :level => 1, :hp => 20),
        ]
        @params = {
          'planet_id' => @planet.id,
          'target_id' => @target.id,
          'unit_ids' => @units.map(&:id)
        }
      end

      @required_params = %w{planet_id target_id unit_ids}

      it "should raise RecordNotFound if it's not that player planet" do
        @planet.player = Factory.create(:player)
        @planet.save!

        lambda do
          invoke @action, @params
        end.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should raise RecordNotFound if the target is not npc" do
        with_config_values 'buildings.npc_solar_plant.npc' => false do
          lambda do
            invoke @action, @params
          end.should raise_error(ActiveRecord::RecordNotFound)
        end
      end

      it "should raise ControllerArgumentError if units are empty" do
        lambda do
          invoke @action, @params.merge('unit_ids' => [])
        end.should raise_error(ControllerArgumentError)
      end

      it "should raise RecordNotFound if some units are not " +
      "in that planet" do
        @units[0].location_id += 1
        @units[0].save!

        lambda do
          invoke @action, @params
        end.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should raise RecordNotFound if some units does not belong " +
      "to that player" do
        @units[0].player = Factory.create(:player)
        @units[0].save!

        lambda do
          invoke @action, @params
        end.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should not create cooldown" do
        invoke @action, @params
        Cooldown.find(:first, :conditions => {
            :location_id => @planet.id,
            :location_type => Location::SS_OBJECT
          }
        ).should be_nil
      end

      it "should push units|attack" do
        should_push("units|attack",
          'notification_id' => an_instance_of(Fixnum))
        invoke @action, @params
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

    describe "pushed" do
      before(:each) do
        @action = "units|attack"
        @notification_id = 100
        @params = {'notification_id' => @notification_id}
        @method = :push
      end
      
      @required_params = %w{notification_id}
      it_should_behave_like "with param options"

      it "should respond with notification id" do
        should_respond_with :notification_id => @notification_id
        push @action, @params
      end
    end
  end

  describe "units|move" do
    before(:each) do
      @action = "units|move"
      @unit_ids = [1, 2, 3]
      @source = SolarSystemPoint.new(10, 1, 0)
      @target = SolarSystemPoint.new(
        Factory.create(:solar_system).id,
        1,
        0
      )
      FowSsEntry.increase(@target.id, player)
      @jg = Factory.create(:sso_jumpgate)
      @params = {
        'unit_ids' => @unit_ids,
        'source' => @source.location_attrs.stringify_keys,
        'target' => @target.location_attrs.stringify_keys,
        'avoid_npc' => true
      }
    end

    @required_params = %w{unit_ids source target}
    it_should_behave_like "with param options"

    it "should invoke UnitMover" do
      UnitMover.should_receive(:move).with(player.id, @unit_ids, @source,
        @target, @params['avoid_npc']
      ).and_return(Factory.create(:route))
      invoke @action, @params
    end

    it "should not return anything" do
      route = Factory.create(:route)
      UnitMover.should_receive(:move).and_return(route)
      @controller.should_not_receive(:respond)
      invoke @action, @params
    end

    it "should raise GameLogicError if target is not visible" do
      FowSsEntry.decrease(@target.id, player)
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end
  end

  describe "units|movement_prepare" do
    before(:each) do
      @action = "units|movement_prepare"
      @params = {'route' => :route, 'unit_ids' => :unit_ids,
        'route_hops' => :route_hops}
      @method = :push
    end

    @required_params = %w{route unit_ids route_hops}
    it_should_behave_like "with param options"
    it_should_behave_like "only push"
  end

  describe "units|movement" do
    before(:each) do
      @action = "units|movement"
      @params = {
        'units' => [
          Factory.create!(:u_dart),
          Factory.create!(:u_dart),
        ],
        'route_hops' => :route_hops,
        'hide_id' => :hide_id
      }
      @method = :push
    end

    @required_params = %w{units route_hops hide_id}
    it_should_behave_like "with param options"
    it_should_behave_like "only push"

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

    it "should respond with hide_id" do
      push @action, @params
      response_should_include(:hide_id => @params['hide_id'])
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

    @required_params = %w{planet_id unit_id x y}
    it_should_behave_like "with param options"

    it "should not fail if unit is in another unit in same planet" do
      @unit.location = Factory.create(:unit, :location => @planet)
      @unit.save!

      lambda do
        invoke @action, @params
      end.should_not raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if player doesn't own that planet" do
      @planet.player = nil
      @planet.save!

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
      @transporter = Factory.create(:u_with_storage, :location => @planet,
        :player => player)
      @units = [
        Factory.create(:u_loadable_test, :location => @planet,
          :player => player),
        Factory.create(:u_loadable_test, :location => @planet,
          :player => player)
      ]
      @params = {'unit_ids' => @units.map(&:id),
        'transporter_id' => @transporter.id}
    end

    @required_params = %w{unit_ids transporter_id}
    it_should_behave_like "with param options"

    it "should fail if transporter does not belong to player" do
      @transporter.player = Factory.create(:player)
      @transporter.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if unit does not belong to player" do
      @units[0].player = Factory.create(:player)
      @units[0].save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should raise error if transporter is not in same location" do
      @transporter.location = Factory.create(:planet)
      @transporter.save!

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should move units" do
      invoke @action, @params
      @units.each(&:reload)
      @units.map(&:location).should == [@transporter.location_point] * 2
    end

    it "should return true" do
      invoke(@action, @params).should be_true
    end
  end

  describe "units|unload" do
    before(:each) do
      @action = "units|unload"
      @planet = Factory.create(:planet, :player => player)
      @transporter = Factory.create(:u_with_storage, :location => @planet,
        :player => player)
      @units = [
        Factory.create(:u_loadable_test, :location => @transporter,
          :player => player),
        Factory.create(:u_loadable_test, :location => @transporter,
          :player => player),
      ]
      @params = {'unit_ids' => @units.map(&:id),
        'transporter_id' => @transporter.id}
    end

    @required_params = %w{unit_ids transporter_id}
    it_should_behave_like "with param options"

    it "should fail if some of the units are not found" do
      @units[0].destroy
      
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail if transporter does not belong to player" do
      @transporter.player = Factory.create(:player)
      @transporter.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if transporter is not in planet" do
      @transporter.location = SolarSystemPoint.new(
        @planet.solar_system_id, 0, 0)
      @transporter.save!

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end
    
    it "should fail if planet belongs to enemy" do
      @planet.player = Factory.create(:player)
      @planet.save!

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end
    
    it "should not fail if planet belongs to self" do
      lambda do
        invoke @action, @params
      end.should_not raise_error(GameLogicError)
    end
    
    it "should not fail if planet belongs to ally" do
      ally, alliance = create_alliance(player)

      @planet.player = ally
      @planet.save!

      lambda do
        invoke @action, @params
      end.should_not raise_error(GameLogicError)
    end

    it "should fail if planet belongs to nap" do
      nap, alliance, nap_alliance = create_nap(player)

      @planet.player = nap
      @planet.save!

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should move units" do
      invoke @action, @params
      @units.each(&:reload)
      @units.map(&:location).should == [@planet.location_point] * 2
    end

    it "should return true" do
      invoke(@action, @params).should be_true
    end
  end

  describe "units|transfer_resources" do
    before(:each) do
      @action = "units|transfer_resources"
      @planet = Factory.create(:planet, :player => player)
      set_resources(@planet, 100, 100, 100)
      @transporter = Factory.create(:u_with_storage, :location => @planet,
        :player => player)
      @params = {'transporter_id' => @transporter.id, 'metal' => 10,
        'energy' => 10, 'zetium' => 10}
    end

    @required_params = %w{transporter_id metal energy zetium}
    it_should_behave_like "with param options"

    describe "loading" do
      it "should fail if planet belongs to ally" do
        ally, alliance = create_alliance(player)

        @planet.player = ally
        @planet.save!

        lambda do
          invoke @action, @params
        end.should raise_error(GameLogicError)
      end

      it "should fail if planet belongs to nap" do
        nap, alliance, nap_alliance = create_nap(player)

        @planet.player = nap
        @planet.save!

        lambda do
          invoke @action, @params
        end.should raise_error(GameLogicError)
      end

      it "should raise error if planet does not belong to player" do
        @planet.player = Factory.create(:player)
        @planet.save!

        lambda do
          invoke @action, @params
        end.should raise_error(GameLogicError)
      end
    end

    describe "unloading" do
      before(:each) do
        @transporter.metal = @transporter.energy = @transporter.zetium = 100
        @transporter.stored = Resources.total_volume(@transporter.metal,
          @transporter.energy, @transporter.zetium)
        @transporter.save!
        @params = @params.merge('metal' => -10, 'energy' => -10,
          'zetium' => -10)
      end

      it "should not fail if planet belongs to ally" do
        ally, alliance = create_alliance(player)

        @planet.player = ally
        @planet.save!

        lambda do
          invoke @action, @params
        end.should_not raise_error(GameLogicError)
      end

      it "should fail if planet belongs to nap" do
        nap, alliance, nap_alliance = create_nap(player)

        @planet.player = nap
        @planet.save!

        lambda do
          invoke @action, @params
        end.should raise_error(GameLogicError)
      end

      it "should raise error if planet does not belong to player" do
        @planet.player = Factory.create(:player)
        @planet.save!

        lambda do
          invoke @action, @params
        end.should raise_error(GameLogicError)
      end
    end

    it "should raise error if transporter does not belong to player" do
      @transporter.player = Factory.create(:player)
      @transporter.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should call #transfer_resources! on transporter" do
      Unit.stub_chain(:where, :find).with(@transporter.id).and_return(
        @transporter)
      @transporter.should_receive(:transfer_resources!).with(
        @params['metal'], @params['energy'], @params['zetium'])
      invoke @action, @params
    end

    it "should call #transfer_resources! on transporter (with wreckage)" do
      @transporter.location = @planet.solar_system_point
      @transporter.save!

      Factory.create(:wreckage, :location => @planet.solar_system_point)

      Unit.stub_chain(:where, :find).with(@transporter.id).and_return(
        @transporter)
      @transporter.should_receive(:transfer_resources!).with(
        @params['metal'], @params['energy'], @params['zetium'])
      invoke @action, @params
    end

    it "should just work" do
      invoke @action, @params
    end
  end

  describe "units|show" do
    before(:each) do
      @action = "units|show"
      @transporter = Factory.create(:u_with_storage, :player => player)
      @units = [
        Factory.create(:u_loadable_test, :location => @transporter),
        Factory.create(:u_loadable_test, :location => @transporter),
      ]
      @params = {'unit_id' => @transporter.id}
    end

    @required_params = %w{unit_id}
    it_should_behave_like "with param options"

    it "should work if transporter belongs to ally" do
      player.alliance = Factory.create(:alliance)
      player.save!

      @transporter.player = Factory.create(:player,
        :alliance => player.alliance)
      @transporter.save!

      lambda do
        invoke @action, @params
      end.should_not raise_error(ActiveRecord::RecordNotFound)
    end

    it "should raise not found if transporter doesn't belong to player" do
      @transporter.player = Factory.create(:player)
      @transporter.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should return units" do
      invoke @action, @params
      response_should_include(:units => @units.map(&:as_json))
    end
  end

  describe "units|heal" do
    before(:each) do
      @planet = Factory.create(:planet, :player => player)
      set_resources(@planet, 100000, 100000, 100000)
      @hp_diff = Unit::Crow.hit_points(1) / 2
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
      ally, alliance = create_alliance(player)
      @planet.player = ally; @planet.save!
      
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail in nap planet" do
      nap, nap_alliance = create_nap(player)
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
end