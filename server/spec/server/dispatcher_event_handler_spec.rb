require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class TestObject
  include Parts::Object
end

def test_object_receive(objects, event_name, reason=nil, context=nil)
  objects = [objects] unless objects.is_a?(Array)

  case event_name
  when EventBroker::CREATED
    action = ObjectsController::ACTION_CREATED
    params = {'objects' => objects}
  when EventBroker::CHANGED
    action = ObjectsController::ACTION_UPDATED
    params = {'objects' => objects, 'reason' => reason}
  when EventBroker::DESTROYED
    action = ObjectsController::ACTION_DESTROYED
    params = {'objects' => objects, 'reason' => reason}
  end

  player_ids = [1, 2]
  filter = :filter
  stub = DispatcherEventHandler.stub!(:resolve_objects)
  if context
    stub.with(objects, reason, context)
  else
    stub.with(objects, reason)
  end
  stub.and_return([player_ids, filter])

  player_ids.each do |player_id|
    @dispatcher.should_receive(:push_to_player).with(player_id, action,
      params, filter)
  end

  @handler.fire(objects, event_name, reason)
end

describe DispatcherEventHandler do
  include ControllerSpecHelper

  before(:each) do
    @dispatcher = mock_dispatcher
    @handler = DispatcherEventHandler.new(@dispatcher)
    # Don't get other events, only ones we submit
    EventBroker.unregister(@handler)
  end

  describe "created" do
    it "should handle created objects" do
      test_object_receive(TestObject.new, EventBroker::CREATED)
    end

    it "should handle Event::PlanetObserversChange" do
      event = Event::PlanetObserversChange.new(10, [1,2,3,4])
      filter = DispatcherPushFilter.
        new(DispatcherPushFilter::SS_OBJECT, event.planet_id)

      event.non_observer_ids.each do |player_id|
        @dispatcher.should_receive(:push_to_player).with(
          player_id,
          PlanetsController::ACTION_UNSET_CURRENT,
          {},
          filter
        )
      end

      @handler.fire([event], EventBroker::CREATED, nil)
    end

    it "should handle Event::ApocalypseStart" do
      galaxy = Factory.create(:galaxy, :apocalypse_start => 15.minutes.from_now)
      players = [
        Factory.create(:player, :galaxy => galaxy),
        Factory.create(:player, :galaxy => galaxy),
        Factory.create(:player, :galaxy => galaxy),
        Factory.create(:player, :galaxy => galaxy)
      ]

      players.each do |player|
        @dispatcher.should_receive(:push_to_player).with(
          player.id,
          GalaxiesController::ACTION_APOCALYPSE,
          {'start' => galaxy.apocalypse_start},
          nil
        )
      end

      event = Event::ApocalypseStart.new(galaxy.id, galaxy.apocalypse_start)

      @handler.fire([event], EventBroker::CREATED, nil)
    end
  end
  
  describe "changed" do
    it "should handle changed objects" do
      test_object_receive(TestObject.new, EventBroker::CHANGED, nil,
        DispatcherEventHandler::CONTEXT_CHANGED)
    end
    
    it "should handle changed technologies" do
      obj = Factory.create(:technology)
      lambda do
        @handler.fire([obj], EventBroker::CHANGED, nil)
      end.should_not raise_error
    end

    it "should handle changed construction queue" do
      planet = Factory.create(:planet_with_player)
      constructor = Factory.create(:b_constructor_test, :planet => planet)
      obj = ConstructionQueue::Event.new(constructor.id)

      @dispatcher.should_receive(:push_to_player).with(
        planet.player_id,
        ConstructionQueuesController::ACTION_INDEX,
        {'constructor_id' => constructor.id},
        DispatcherPushFilter.new(DispatcherPushFilter::SS_OBJECT, planet.id)
      )

      @handler.fire([obj], EventBroker::CHANGED, nil)
    end
    
    it "should handle changed player" do
      obj = Factory.create :player
      @dispatcher.stub!(:connected?).with(obj.id).and_return(true)
      @dispatcher.should_receive(:update_player).with(obj)
      @dispatcher.should_receive(:push_to_player).with(
        obj.id,
        PlayersController::ACTION_SHOW
      )
      @handler.fire([obj], EventBroker::CHANGED, nil)
    end

    it "should not update player in dispatcher upon change if it's not " +
    "connected" do
      obj = Factory.create :player
      @dispatcher.stub!(:connected?).with(obj.id).and_return(false)
      @dispatcher.should_not_receive(:update_player)
      @handler.fire([obj], EventBroker::CHANGED, nil)
    end
    
    it "should not fail when planet owners change if there was " +
    "no old owner" do
      new = Factory.create(:player)
      planet = Factory.create(:planet)
      planet.player = new

      lambda do
        @handler.fire([planet], EventBroker::CHANGED,
          EventBroker::REASON_OWNER_CHANGED)
      end.should_not raise_error
    end

    it "should dispatch planets|player_index if planet owners change" do
      old = Factory.create(:player)
      new = Factory.create(:player)
      planet = Factory.create(:planet, :player => old)
      planet.player = new

      @dispatcher.should_receive(:push_to_player).with(
        old.id,
        PlanetsController::ACTION_PLAYER_INDEX
      )
      @dispatcher.should_receive(:push_to_player).with(
        new.id,
        PlanetsController::ACTION_PLAYER_INDEX
      )

      @handler.fire([planet], EventBroker::CHANGED,
        EventBroker::REASON_OWNER_CHANGED)
    end

    it "should dispatch to player if changed units are in buildings" do
      planet = Factory.create(:planet_with_player)
      unit = Factory.create(:unit,
        :location => Factory.create(:b_npc_solar_plant, :planet => planet))
      obj = [unit]
      @dispatcher.should_receive(:push_to_player).with(
        planet.player_id,
        ObjectsController::ACTION_UPDATED,
        {'objects' => obj, 'reason' => nil},
        DispatcherPushFilter.new(DispatcherPushFilter::SS_OBJECT, planet.id)
      )
      @handler.fire(obj, EventBroker::CHANGED, nil)
    end
    
    it "should handle Event::StatusChange" do
      event = Event::StatusChange.new({1 => [2, 3], 10 => [20, 1]})
      
      event.statuses.each do |player_id, changes|
        @dispatcher.should_receive(:push_to_player).with(
          player_id,
          PlayersController::ACTION_STATUS_CHANGE,
          {'changes' => changes},
          nil
        )
        @dispatcher.should_receive(:push_to_player).with(
          player_id,
          RoutesController::ACTION_INDEX
        )
      end
      
      @handler.fire([event], EventBroker::CHANGED, nil)
    end

    describe "fog of war changes" do
      describe "reason galaxy" do
        it "should send galaxy map" do
          player_ids = [1,2,3]
          event = Event::FowChange.new(nil, nil)
          event.stub!(:player_ids).and_return(player_ids)

          player_ids.each do |player_id|
            @dispatcher.should_receive(:push_to_player).with(
              player_id,
              GalaxiesController::ACTION_SHOW
            )
          end

          @handler.fire(event, EventBroker::FOW_CHANGE,
            EventBroker::REASON_GALAXY_ENTRY)
        end
      end

      describe "reason solar system" do
        it "should send updated metadatas" do
          player_ids = [1,2,3]
          metadatas = {
            1 => 'meta1',
            2 => 'meta2',
            3 => 'meta3',
          }
          event = Event::FowChange::SolarSystem.new(0)
          event.stub!(:player_ids).and_return(player_ids)
          event.stub!(:metadatas).and_return(metadatas)

          player_ids.each do |player_id|
            @dispatcher.should_receive(:push_to_player).with(
              player_id,
              ObjectsController::ACTION_UPDATED,
              {
                'objects' => [metadatas[player_id]],
                'reason' => nil
              }
            )
          end

          @handler.fire(event, EventBroker::FOW_CHANGE,
            EventBroker::REASON_SS_ENTRY)
        end

        it "should send destroyed if it was destroyed" do
          player_ids = [1,2,3]
          metadata = SolarSystemMetadata.new(:id => 10)
          event = Event::FowChange::SsDestroyed.new(10, nil, nil)
          event.stub!(:player_ids).and_return(player_ids)
          event.stub!(:metadata).and_return(metadata)

          player_ids.each do |player_id|
            @dispatcher.should_receive(:push_to_player).with(
              player_id,
              ObjectsController::ACTION_DESTROYED,
              {
                'objects' => [metadata],
                'reason' => nil
              }
            )
          end

          @handler.fire(event, EventBroker::FOW_CHANGE,
            EventBroker::REASON_SS_ENTRY)
        end
      end
    end
  end
  
  describe "destroyed" do
    it "should handle destroyed objects" do
      test_object_receive(TestObject.new, EventBroker::DESTROYED, nil,
        DispatcherEventHandler::CONTEXT_DESTROYED)
    end

    it "should dispatch to player if destroyed units are in buildings" do
      planet = Factory.create(:planet_with_player)
      unit = Factory.create(:unit,
        :location => Factory.create(:b_npc_solar_plant, :planet => planet))
      obj = [unit]
      @dispatcher.should_receive(:push_to_player).with(
        planet.player_id,
        ObjectsController::ACTION_DESTROYED,
        {'objects' => obj, 'reason' => nil},
        DispatcherPushFilter.new(DispatcherPushFilter::SS_OBJECT, planet.id)
      )
      @handler.fire(obj, EventBroker::DESTROYED, nil)
    end

  end
  
  describe "movement prepare" do
    before(:each) do
      location = GalaxyPoint.new(
        Factory.create(:galaxy).id, 0, 0
      ).client_location

      alliance = Factory.create(:alliance)
      p1 = Factory.create(:player, :alliance => alliance)
      p2 = Factory.create(:player, :alliance => alliance)
      p3 = Factory.create(:player)
      p4 = Factory.create(:player)

      @friendly_player_ids = [p1.id, p2.id]
      @enemy_player_ids = [p3.id, p4.id]
      @filter = :filter

      DispatcherEventHandler.stub!(:resolve_location).with(
        location).and_return(
          [@friendly_player_ids + @enemy_player_ids, @filter]
      )
      
      @route = Factory.create(:route, :source => location, :player => p1,
        :current => location)
      @units = [
        Factory.create!(:u_dart, :route => @route, :player => p1,
          :location => location),
        Factory.create!(:u_dart, :route => @route, :player => p2,
          :location => location),
        Factory.create!(:u_dart, :route => @route, :player => p3,
          :location => location),
        Factory.create!(:u_dart, :route => @route, :player => p4,
          :location => location),
      ]

      @route_hops = [
        Factory.create(:route_hop, :route => @route,
          :location => GalaxyPoint.new(@route.source.id, 1, 2),
          :next => true, :index => 0),
        Factory.create(:route_hop, :route => @route,
          :location => GalaxyPoint.new(@route.source.id, 2, 2),
          :next => false, :index => 1)
      ]
      
      @event = Event::MovementPrepare.new(@route, @units.map(&:id))
    end

    it "should handle friends" do
      @friendly_player_ids.each do |player_id|
        @dispatcher.should_receive(:push_to_player).with(
          player_id,
          UnitsController::ACTION_MOVEMENT_PREPARE,
          {
            'route' => @route.as_json(:mode => :normal),
            'unit_ids' => @event.unit_ids,
            'route_hops' => @route_hops
          },
          nil
        )
      end
      @handler.fire(@event, EventBroker::MOVEMENT_PREPARE, nil)
    end

    it "should handle enemies" do
      @enemy_player_ids.each do |player_id|
        @dispatcher.should_receive(:push_to_player).with(
          player_id,
          UnitsController::ACTION_MOVEMENT_PREPARE,
          {
            'route' => @route.as_json(:mode => :enemy),
            'unit_ids' => @event.unit_ids,
            'route_hops' => [@route_hops[0]]
          },
          @filter
        )
      end
      @handler.fire(@event, EventBroker::MOVEMENT_PREPARE, nil)
    end

    it "should not crash upon NPC movement" do
      @route.player = nil
      @route.save!
      
      @handler.fire(@event, EventBroker::MOVEMENT_PREPARE, nil)
    end
    
    it "should not send null route hops for enemies if there are no hops" +
    " in this zone" do
      @route_hops.each(&:destroy)
      @enemy_player_ids.each do |player_id|
        @dispatcher.should_receive(:push_to_player).with(
          player_id,
          UnitsController::ACTION_MOVEMENT_PREPARE,
          {
            'route' => @route.as_json(:mode => :enemy),
            'unit_ids' => @event.unit_ids,
            'route_hops' => []
          },
          @filter
        )
      end
      @handler.fire(@event, EventBroker::MOVEMENT_PREPARE, nil)
    end
  end

  describe "movement" do
    it "should do nothing if player is NPC"
    it "should not send message if moved in zone and stopped (last hop)"
    it "should not send route_hops [nil] if changed zones and stopped"
    it "should not send route_hops [nil] if moved in zone to " +
    "visible area and stopped"
    it "should not send next hop from other zone if movement happened " +
    "in zone"
  end

  describe ".resolve_location" do
    it "should resolve GALAXY" do
      galaxy = Factory.create(:galaxy)
      point = GalaxyPoint.new(galaxy.id, 0, 0)
      unit = Factory.create(:unit, :location => point)
      Factory.create(:fge_player, :player => unit.player, :x => -5, :y => -5,
        :x_end => 5, :y_end => 5)
      DispatcherEventHandler.resolve_location(unit.location).should == [
        FowGalaxyEntry.observer_player_ids(point.id, point.x, point.y),
        nil
      ]
    end

    it "should resolve SOLAR_SYSTEM" do
      ss = Factory.create(:solar_system)
      point = SolarSystemPoint.new(ss.id, 0, 0)
      unit = Factory.create(:unit, :location => point)
      Factory.create(:fse_player, :player => unit.player, :solar_system => ss)
      DispatcherEventHandler.resolve_location(unit.location).should == [
        FowSsEntry.observer_player_ids(point.id),
        DispatcherPushFilter.new(DispatcherPushFilter::SOLAR_SYSTEM, point.id)
      ]
    end

    it "should resolve SS_OBJECT" do
      planet = Factory.create(:planet_with_player)
      unit = Factory.create(:unit, :location => planet)
      DispatcherEventHandler.resolve_location(unit.location).should == [
        planet.observer_player_ids,
        DispatcherPushFilter.new(DispatcherPushFilter::SS_OBJECT, planet.id)
      ]
    end

    it "should resolve UNIT" do
      planet = Factory.create(:planet_with_player)
      transporter = Factory.create(:unit, :location => planet)
      unit = Factory.create(:unit, :location => transporter)
      DispatcherEventHandler.resolve_location(unit.location).should == [
        planet.observer_player_ids,
        DispatcherPushFilter.new(DispatcherPushFilter::SS_OBJECT, planet.id)
      ]
    end
  end

  describe ".resolve_movement_location" do
    it "should return unmodified values if location is not an galaxy point" do
      point = SolarSystemPoint.new(1, 0, 0)
      DispatcherEventHandler.should_receive(:resolve_location).
        with(point).and_return([:player_ids, :filter])
      DispatcherEventHandler.resolve_movement_location(
        point,
        [1,2,3]
      ).should == [:player_ids, :filter]
    end

    it "should add friendly ids if location is galaxy point" do
      point = GalaxyPoint.new(1, 0, 0)
      DispatcherEventHandler.should_receive(:resolve_location).
        with(point).and_return([[1], :filter])
      DispatcherEventHandler.resolve_movement_location(
        point,
        [1,2,3]
      ).should == [[1,2,3], :filter]
    end
  end

  describe ".resolve_objects" do
    it "should resolve Building" do
      planet = Factory.create(:planet)
      player_ids = [1,2,3]
      obj = Factory.create(:building, :planet => planet)
      obj.stub!(:planet).and_return(planet.tap do |p|
        p.stub(:observer_player_ids).and_return(player_ids)
      end)
      DispatcherEventHandler.resolve_objects(obj, :reason).should == [
        player_ids, DispatcherPushFilter.new(
          DispatcherPushFilter::SS_OBJECT, planet.id)
      ]
    end

    it "should resolve Unit" do
      obj = Factory.create(:unit)
      DispatcherEventHandler.should_receive(:resolve_location).with(
        obj.location)
      DispatcherEventHandler.resolve_objects(obj, :reason)
    end

    it "should resolve Route (changed context)" do
      obj = Factory.create(:route)
      player = obj.player
      player_ids = [1,2,3]
      obj.stub!(:player).and_return(player.tap do |p|
        p.stub!(:friendly_ids).and_return(player_ids)
      end)
      DispatcherEventHandler.resolve_objects(obj, :reason,
        DispatcherEventHandler::CONTEXT_CHANGED
      ).should == [player_ids, nil]
    end
    
    it "should not fail with NPC Route (changed context)" do
      obj = Factory.create(:route, :player => nil)
      DispatcherEventHandler.resolve_objects(obj, :reason,
        DispatcherEventHandler::CONTEXT_CHANGED
      ).should == [[], nil]
    end

    it "should resolve Route (destroyed context for friendly ids)" do
      obj = Factory.create(:route)

      obj.stub_chain(:player, :friendly_ids).and_return([1, 2])
      DispatcherEventHandler.stub!(:resolve_location).
        with(obj.current).and_return([[2, 3, 4], :filter])

      player_ids, filter = DispatcherEventHandler.resolve_location(
        obj.current)
      player_ids += obj.player.friendly_ids

      DispatcherEventHandler.resolve_objects(obj, :reason,
        DispatcherEventHandler::CONTEXT_DESTROYED
      ).should == [player_ids.uniq, nil]
    end

    it "should not fail with NPC Route (destroyed context)" do
      obj = Factory.create(:route, :player => nil)

      DispatcherEventHandler.resolve_objects(obj, :reason,
        DispatcherEventHandler::CONTEXT_DESTROYED
      ).should == [[], nil]
    end
    
    it "should resolve Planet" do
      obj = Factory.create(:planet)
      player_ids = [1, 2, 3]
      SolarSystem.should_receive(:observer_player_ids).with(
        obj.solar_system_id).and_return(player_ids)

      DispatcherEventHandler.resolve_objects(obj, :reason).should == [
        player_ids,
        DispatcherPushFilter.new(
          DispatcherPushFilter::SOLAR_SYSTEM, obj.solar_system_id
        )
      ]
    end

    it "should resolve Planet for resources change" do
      obj = Factory.create(:planet_with_player)

      DispatcherEventHandler.resolve_objects(obj,
        EventBroker::REASON_OWNER_PROP_CHANGE
      ).should == [[obj.player_id], nil]
    end

    it "should resolve ConstructionQueueEntry" do
      obj = Factory.create(:construction_queue_entry)
      player_ids = [1, 2]; planet_id = 10
      obj.stub_chain(
        :constructor, :planet, :player, :friendly_ids
      ).and_return(player_ids)
      obj.stub_chain(:constructor, :planet, :id).and_return(planet_id)

      DispatcherEventHandler.resolve_objects(obj, :reason).should == [
        player_ids,
        DispatcherPushFilter.new(DispatcherPushFilter::SS_OBJECT, planet_id)
      ]
    end

    it "should resolve Notification" do
      obj = Factory.create(:notification)
      DispatcherEventHandler.resolve_objects(obj, :reason).should == [
        [obj.player_id], nil]
    end

    it "should resolve ClientQuest" do
      player_id = 2
      obj = ClientQuest.new(1, player_id)
      DispatcherEventHandler.resolve_objects(obj, :reason).should == [
        [player_id], nil
      ]
    end

    it "should resolve QuestProgress" do
      obj = Factory.create(:quest_progress)
      DispatcherEventHandler.resolve_objects(obj, :reason).should == [
        [obj.player_id], nil
      ]
    end

    it "should resolve ObjectiveProgress" do
      obj = Factory.create(:objective_progress)
      DispatcherEventHandler.resolve_objects(obj, :reason).should == [
        [obj.player_id], nil
      ]
    end

    it "should resolve Wreckage" do
      obj = Factory.create(:wreckage)
      DispatcherEventHandler.resolve_objects(obj, :reason).should ==
        DispatcherEventHandler.resolve_location(obj.location)
    end

    it "should resolve Cooldown" do
      obj = Factory.create(:cooldown)
      DispatcherEventHandler.resolve_objects(obj, :reason).should ==
        DispatcherEventHandler.resolve_location(obj.location)
    end

    it "should resolve SolarSystem" do
      ss = Factory.create(:solar_system)
      DispatcherEventHandler.resolve_objects(ss, :reason).should ==
        DispatcherEventHandler.resolve_location(ss.galaxy_point)
    end

    it "should resolve SolarSystemMetadata" do
      ss = Factory.create(:solar_system)
      obj = SolarSystemMetadata.new(:id => ss.id)
      DispatcherEventHandler.resolve_objects(obj, :reason).should ==
        DispatcherEventHandler.resolve_location(ss.galaxy_point)
    end
    
    it "should resolve Tile" do
      obj = Factory.create(:tile)
      DispatcherEventHandler.resolve_objects(obj, :reason).should ==
        DispatcherEventHandler.resolve_location(obj.planet.location_point)
    end
  end
end

