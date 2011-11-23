require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe RouteHop do
  describe ".for" do
    before(:all) do
      @player1 = Factory.create :player
      @player2 = Factory.create :player
      @route1 = Factory.create :route, :player => @player1
      @route2 = Factory.create :route, :player => @player2
      @route_hop1 = Factory.create :route_hop, :route => @route1,
        :next => true, :index => 0
      @route_hop2 = Factory.create :route_hop, :route => @route1,
        :next => false, :index => 1
      @route_hop3 = Factory.create :route_hop, :route => @route2,
        :next => true, :index => 0
      @route_hop4 = Factory.create :route_hop, :route => @route2,
        :next => false, :index => 1
      @result = RouteHop.for([@player1.id]).all
    end

    it "should include route hops for player" do
      @result.should include(@route_hop1)
      @result.should include(@route_hop2)
    end

    it "should include next route hops for other players" do
      @result.should include(@route_hop3)
    end

    it "should only include next route hop for other players" do
      @result.should_not include(@route_hop4)
    end

    it "should also support non array argument" do
      RouteHop.for(@player1.id).all.should == @result
    end
  end

  describe ".hops_in_zone" do
    before(:all) do
      @route = Factory.create :route
      @ss = Factory.create :solar_system
      @zone_hop = Factory.create :route_hop, :route => @route,
        :location => SolarSystemPoint.new(@ss.id, 0, 0)
      @non_zone_hop = Factory.create :route_hop, :route => @route,
        :location => GalaxyPoint.new(@ss.galaxy_id, 0, 0), :index => 1
      @non_route_hop = Factory.create :route_hop, 
        :location => SolarSystemPoint.new(@ss.id, 0, 0)
      @result = RouteHop.hops_in_zone(@route.id,
        @zone_hop.location.object.zone)
    end

    it "should include hops in that zone" do
      @result.should include(@zone_hop)
    end

    it "should not return hops from other route" do
      @result.should_not include(@non_route_hop)
    end

    it "should not return hops from other zone" do
      @result.should_not include(@non_zone_hop)
    end
  end

  describe ".find_all_by_player_and_units" do
    before(:all) do
      @location_1 = Factory.create :solar_system
      @location_2 = Factory.create :solar_system
      @location_point_1 = SolarSystemPoint.new(@location_1.id, 1, 0)
      @location_point_2 = SolarSystemPoint.new(@location_1.id, 2, 0)
      @location_point_3 = SolarSystemPoint.new(@location_2.id, 1, 0)

      @alliance = Factory.create :alliance

      @yours = {:player => Factory.create(:player, :alliance => @alliance)}
      @ally = {:player => Factory.create(:player, :alliance => @alliance)}
      @enemy = {:player => Factory.create(:player)}

      [
        @yours, @ally, @enemy
      ].each do |side|
        side[:route] = Factory.create :route, :player => side[:player]
        side[:unit] = Factory.create :u_crow,
          @location_point_1.location_attrs.merge(
            :route => side[:route], :player => side[:player]
          )
        side[:route_hops] = [
          Factory.create(:route_hop,
            @location_point_1.location_attrs.merge(
              :route => side[:route], :next => true, :index => 0
            )
          ),
          Factory.create(:route_hop, 
            @location_point_2.location_attrs.merge(
              :route => side[:route], :next => false, :index => 1
            )
          ),
          Factory.create(:route_hop, 
            @location_point_3.location_attrs.merge(
              :route => side[:route], :next => false, :index => 2
            )
          ),
        ]
      end

      @units = [@yours[:unit], @ally[:unit], @enemy[:unit]]
      @result = RouteHop.find_all_for_player(
        @yours[:player], @location_1, @units
      )
    end

    it "should not select route hops out of that location" do
      @result.should_not include(@yours[:route_hops][2])
    end

    it "should select all hops in that location for own units" do
      @result.should include(@yours[:route_hops][0])
      @result.should include(@yours[:route_hops][1])
    end

    it "should select all hops in that location for alliance units" do
      @result.should include(@ally[:route_hops][0])
      @result.should include(@ally[:route_hops][1])
    end

    it "should only select next hop in that location for other units" do
      @result.should include(@enemy[:route_hops][0])
      @result.should_not include(@enemy[:route_hops][1])
    end
  end

  describe "#as_json" do
    it "should return Hash on #as_json" do
      model = Factory.create(:route_hop)
      model.as_json.should == {
        "route_id" => model.route_id,
        "location" => model.location.as_json,
        "arrives_at" => model.arrives_at.as_json,
        "index" => model.index
      }
    end

    required_fields = %w{route_id location arrives_at index}
    ommited_fields = RouteHop.columns.map(&:name) - required_fields
    it_behaves_like "as json", Factory.create(:route_hop), nil,
                    required_fields, ommited_fields
  end

  describe "#hop_type" do
    it "should return :galaxy if location_type == Location::GALAXY" do
      Factory.build(:route_hop,
        :location => GalaxyPoint.new(1, 2, 3)
      ).hop_type.should == :galaxy
    end

    it "should return :solar_system if " +
    "location_type == Location::SOLAR_SYSTEM" do
      Factory.build(:route_hop,
        :location => SolarSystemPoint.new(1, 1, 90)
      ).hop_type.should == :solar_system
    end

    it "should return :solar_system if " +
    "location_type == Location::PLANET" do
      Factory.build(:route_hop, 
        :location => Factory.create(:planet).location
      ).hop_type.should == :solar_system
    end
  end

  describe ".on_callback" do
    before(:each) do
      @galaxy = Factory.create :galaxy
      @start_location = GalaxyPoint.new(@galaxy.id, 19, 40)
      @hop_target = GalaxyPoint.new(@galaxy.id, 20, 40)

      @player = Factory.create :player, :galaxy => @galaxy
      @route = Factory.create(:route, :player => @player,
        :source => @start_location.client_location,
        :current => @start_location.client_location
      )
      @route.reload
      @hop = Factory.create :route_hop, :route => @route,
        :location => @hop_target
      unit_overrides = {
        :route_id => @route.id,
        :location => @start_location,
        :player_id => @player.id
      }
      @units = [
        Factory.create(:unit, unit_overrides),
        Factory.create(:unit, unit_overrides),
        Factory.create(:unit, unit_overrides)
      ]
    end

    it "should raise ArgumentError if event is not EVENT_MOVEMENT" do
      lambda do
        RouteHop.on_callback(@hop.id,
          CallbackManager::EVENT_CONSTRUCTION_FINISHED)
      end.should raise_error(ArgumentError)
    end

    it "should call SsObject::Planet.changing_viewable" do
      SsObject::Planet.should_receive(:changing_viewable).with(
        [@start_location, @hop_target]).and_return(true)
      RouteHop.on_callback(@hop.id, CallbackManager::EVENT_MOVEMENT)
    end

    it "should move the units in the route" do
      RouteHop.on_callback(@hop.id, CallbackManager::EVENT_MOVEMENT)
      @units.map do |unit|
        unit.reload
        unit.location
      end.should == [@hop_target] * @units.size
    end

    it "should delete this hop" do
      RouteHop.on_callback(@hop.id, CallbackManager::EVENT_MOVEMENT)
      lambda do
        RouteHop.find(@hop.id)
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should check location for units" do
      Combat::LocationCheckerAj.should_receive(:check_location).with(
        @hop.location)
      RouteHop.on_callback(@hop.id, CallbackManager::EVENT_MOVEMENT)
    end

    describe "when zones change" do
      before(:each) do
        @solar_system = Factory.create(:solar_system, :galaxy => @galaxy)
        @hop.location = SolarSystemPoint.new(@solar_system.id, 0, 0)
        @hop.save!
        @second_hop = Factory.create(:route_hop,
          :location => SolarSystemPoint.new(@solar_system.id, 1, 0),
          :route => @route,
          :arrives_at => @hop.arrives_at + 5.minutes,
          :index => @hop.index + 1
        )
      end

      it "should call .handle_fow_change" do
        RouteHop.should_receive(:handle_fow_change).with(
          an_instance_of(Event::Movement))
        RouteHop.on_callback(@hop.id, CallbackManager::EVENT_MOVEMENT)
      end

      it "should update Route#jumps_at to next zone #arrives_at" do
        planet = Factory.create(:planet, :solar_system => @solar_system)
        change_hop = Factory.create(:route_hop,
          :location => planet.location_point,
          :route => @route,
          :arrives_at => @second_hop.arrives_at + 10.minutes,
          :index => @second_hop.index + 1)
        RouteHop.on_callback(@hop.id, CallbackManager::EVENT_MOVEMENT)
        @route.reload
        @route.jumps_at.should be_within(SPEC_TIME_PRECISION).
                                 of(change_hop.arrives_at)
      end

      it "should update clear jumps_at if there are no more zone changes" do
        lambda do
          RouteHop.on_callback(@hop.id, CallbackManager::EVENT_MOVEMENT)
          @route.reload
        end.should change(@route, :jumps_at).to(nil)
      end
    end

    describe "when zone do not change" do
      it "should not call .handle_fow_change" do
        RouteHop.should_not_receive(:handle_fow_change)
        RouteHop.on_callback(@hop.id, CallbackManager::EVENT_MOVEMENT)
      end

      it "should not update Route#jumps_at" do
        # Create a hop so route would not be destroyed
        Factory.create(:route_hop,
          :location => @hop_target,
          :route => @route,
          :arrives_at => @hop.arrives_at + 5.minutes,
          :index => @hop.index + 1
        )

        lambda do
          RouteHop.on_callback(@hop.id, CallbackManager::EVENT_MOVEMENT)
          @route.reload
        end.should_not change(@route, :jumps_at)
      end
    end

    describe "when not last hop" do
      before(:each) do
        @next_hop_target = GalaxyPoint.new(@galaxy.id, 21, 40)
        @next_hop = Factory.create :route_hop, 
          :route => @hop.route, :index => @hop.index + 1,
          :location => @next_hop_target
      end

      it "should update current route location" do
        route = @hop.route
        lambda do
          RouteHop.on_callback(@hop.id, CallbackManager::EVENT_MOVEMENT)
          route.reload
        end.should change(route, :current).to(
          @hop_target.client_location
        )
      end

      it "should set hop with index + 1 to be next hop" do
        lambda do
          RouteHop.on_callback(@hop.id, CallbackManager::EVENT_MOVEMENT)
          @next_hop.reload
        end.should change(@next_hop, :next).from(false).to(true)
      end

      it "should register next hop to callback manager" do
        RouteHop.on_callback(@hop.id, CallbackManager::EVENT_MOVEMENT)
        CallbackManager.has?(@next_hop, CallbackManager::EVENT_MOVEMENT,
          @next_hop.arrives_at).should be_true
      end
    end

    describe "when last hop" do
      it "should update current route location" do
        route = @hop.route
        RouteHop.on_callback(@hop.id, CallbackManager::EVENT_MOVEMENT)
        SPEC_EVENT_HANDLER.events.find do |objects, event_name, reason|
          objects == [route] && event_name == EventBroker::DESTROYED
        end[0][0].current.should == @hop_target.client_location
      end

      it "should destroy the route" do
        RouteHop.on_callback(@hop.id, CallbackManager::EVENT_MOVEMENT)
        lambda do
          Route.find(@hop.route_id)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
      
      it "should dispatch destroyed with appropriate reason" do
        should_fire_event(@hop.route, EventBroker::DESTROYED, 
          EventBroker::REASON_COMPLETED) do
          RouteHop.on_callback(@hop.id, CallbackManager::EVENT_MOVEMENT)
        end
      end

      it "should fire event before destroying the route so units " +
      "still belong to it" do
        handler = Object.new
        def handler.fire(object, event_name, reason)
          @units = object.route.units.all if object.is_a?(Event::Movement)
        end
        def handler.units; @units; end
        EventBroker.register(handler)

        RouteHop.on_callback(@hop.id, CallbackManager::EVENT_MOVEMENT)

        handler.units.should_not be_blank
      end
    end
  end

  describe ".handle_fow_change" do
    before(:each) do
      @solar_system = Factory.create(:solar_system)
    end

    it "should increase fow ss entry if entering ss" do
      current = SolarSystemPoint.new(@solar_system.id, 0, 0)
      route = Factory.create(:route,
        :current => current.client_location,
        :cached_units => {"Mule" => 3, "Crow" => 5}
      )
      previous_location = GalaxyPoint.new(@solar_system.galaxy_id, 0, 0)
      current_hop = Factory.create(:route_hop, :route => route,
        :location => current)

      FowSsEntry.should_receive(:increase).with(current.id,
        route.player, 8)
      RouteHop.handle_fow_change(
        Event::Movement.new(route, previous_location, current_hop, nil)
      )
    end

    describe "jumping to planet" do
      before(:each) do
        @current = Factory.create(:planet, :solar_system => @solar_system
          ).location
        @previous_location = SolarSystemPoint.new(@solar_system.id, 0, 0)
        @route = Factory.create(:route,
          :current => @current.client_location,
          :cached_units => {"Mule" => 3, "Crow" => 5}
        )
        @current_hop = Factory.create(:route_hop, :route => @route,
          :location => @current)
      end

      it "should not decrease fow ss entry" do
        FowSsEntry.should_not_receive(:decrease)
        RouteHop.handle_fow_change(
          Event::Movement.new(@route, @previous_location, @current_hop, nil)
        )
      end

      it "should recalculate solar system metadata" do
        FowSsEntry.should_receive(:recalculate).with(@solar_system.id)
        RouteHop.handle_fow_change(
          Event::Movement.new(@route, @previous_location, @current_hop, nil)
        )
      end
    end

    describe "jumping from planet" do
      before(:each) do
        @current = SolarSystemPoint.new(@solar_system.id, 0, 0)
        @previous_location = Factory.create(:planet,
          :solar_system => @solar_system).location
        @route = Factory.create(:route,
          :current => @current.client_location,
          :cached_units => {"Mule" => 3, "Crow" => 5}
        )
        @current_hop = Factory.create(:route_hop, :route => @route,
          :location => @current)
      end

      it "should not increase fow ss entry" do
        FowSsEntry.should_not_receive(:increase)
        RouteHop.handle_fow_change(
          Event::Movement.new(@route, @previous_location, @current_hop, nil)
        )
      end

      it "should recalculate solar system metadata" do
        FowSsEntry.should_receive(:recalculate).with(@solar_system.id)
        RouteHop.handle_fow_change(
          Event::Movement.new(@route, @previous_location, @current_hop, nil)
        )
      end
    end

    it "should decrease fow ss entry if leaving ss" do
      current = GalaxyPoint.new(@solar_system.galaxy_id, 0, 0)
      route = Factory.create(:route,
        :current => current.client_location,
        :cached_units => {
          "Mule" => 3,
          "Crow" => 5
        }
      )
      previous_location = SolarSystemPoint.new(@solar_system.id, 0, 0)
      current_hop = Factory.create(:route_hop, :route => route,
        :location => current)

      FowSsEntry.should_receive(:decrease).with(previous_location.id,
        route.player, 8)
      RouteHop.handle_fow_change(
        Event::Movement.new(route, previous_location, current_hop, nil)
      )
    end
  end
end
