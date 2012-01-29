require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DispatcherEventHandler do
  include ControllerSpecHelper

  before(:each) do
    @dispatcher = mock_dispatcher
    @handler = DispatcherEventHandler.new(@dispatcher)
    # Don't get other events, only ones we submit
    EventBroker.unregister(@handler)
  end

  describe "creation/change/destruction" do
    let(:object) { :object }
    let(:reason) { :reason }

    it "should pass creation to DispatcherEventHandler::Handler::Created" do
      DispatcherEventHandler::Handler::Created.should_receive(:handle).with(
        @dispatcher, object, reason
      )
      @handler.fire(object, EventBroker::CREATED, reason)
    end

    it "should pass change to DispatcherEventHandler::Handler::Changed" do
      DispatcherEventHandler::Handler::Changed.should_receive(:handle).with(
        @dispatcher, object, reason
      )
      @handler.fire(object, EventBroker::CHANGED, reason)
    end

    it "should pass destruction to DispatcherEventHandler::Handler::Destroyed" do
      DispatcherEventHandler::Handler::Destroyed.should_receive(:handle).with(
        @dispatcher, object, reason
      )
      @handler.fire(object, EventBroker::DESTROYED, reason)
    end
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

        it "should send created if it was created" do
          player_ids = [1,2,3]
          metadatas = player_ids.each_with_object({}) do |id, hash|
            hash[id] = mock(SolarSystemMetadata)
          end
          event = Event::FowChange::SsCreated.new(10, 5, 50, [])
          event.stub!(:player_ids).and_return(player_ids)
          event.stub!(:metadatas).and_return(metadatas)

          player_ids.each do |player_id|
            @dispatcher.should_receive(:push_to_player).with(
              player_id,
                ObjectsController::ACTION_CREATED,
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
          event = Event::FowChange::SsDestroyed.new(10, player_ids)

          player_ids.each do |player_id|
            @dispatcher.should_receive(:push_to_player).with(
              player_id,
              ObjectsController::ACTION_DESTROYED,
              {
                'objects' => [event.metadata],
                'reason' => nil
              }
            )
          end

          @handler.fire(event, EventBroker::FOW_CHANGE,
            EventBroker::REASON_SS_ENTRY)
        end
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

    describe "when spot is visible" do
      before(:each) do
        DispatcherEventHandler::LocationResolver.should_receive(:resolve).
          with(@route.current).
          and_return([@friendly_player_ids + @enemy_player_ids, @filter])
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

      describe "if there are no hops in this zone" do
        it "should not send null route hops for enemies" do
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
    end

    describe "when spot is not visible" do
      before(:each) do
        DispatcherEventHandler::LocationResolver.should_receive(:resolve).
          with(@route.current).and_return([[], @filter])
      end

      it "should dispatch to friendly" do
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

      it "should not dispatch to enemies" do
        @enemy_player_ids.each do |player_id|
          @dispatcher.should_not_receive(:push_to_player).with(
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
end

