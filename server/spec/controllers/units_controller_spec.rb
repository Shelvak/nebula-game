require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

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

      set_resources(@planet.resources_entry, 10000, 10000, 10000)

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

        @planet = Factory.create :planet_with_player, :player => player
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
            :location_type => Location::PLANET
          }
        ).should be_nil
      end

      it "should push units|attack" do
        should_push(UnitsController::ACTION_ATTACK,
          'notification_id' => an_instance_of(Fixnum))
        invoke @action, @params
      end

      it "should destroy building if there are no more npc units there" do
        @target_units.each(&:destroy)
        invoke @action, @params
        lambda do
          @target.reload
        end.should raise_error(ActiveRecord::RecordNotFound)
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
      @jg = Factory.create(:p_jumpgate)
      @params = {
        'unit_ids' => @unit_ids,
        'source' => @source.location_attrs.stringify_keys,
        'target' => @target.location_attrs.stringify_keys,
        'through_id' => @jg.id
      }
    end

    @required_params = %w{unit_ids source target through_id}
    it_should_behave_like "with param options"

    it "should invoke UnitMover" do
      UnitMover.should_receive(:move).with(player.id, @unit_ids, @source,
        @target, @jg).and_return(Factory.create(:route))
      invoke @action, @params
    end

    it "should invoke UnitMover without JG if through_id is nil" do
      UnitMover.should_receive(:move).with(player.id, @unit_ids, @source,
        @target, nil).and_return(Factory.create(:route))
      invoke @action, @params.merge('through_id' => nil)
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

    it "should respond with units wrapped in statuses" do
      push @action, @params
      response_should_include(:units =>
          StatusResolver.new(player).resolve_objects(@params['units'])
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
end