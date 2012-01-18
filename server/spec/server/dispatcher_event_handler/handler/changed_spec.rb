require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper.rb')
)

describe DispatcherEventHandler::Handler::Changed do
  include DispatcherEventHandlerObjectHelpers

  let(:dispatcher) { mock(Dispatcher) }
  let(:reason) { :reason }

  describe ".handle" do
    it "should handle changed objects" do
      objs = test_object_change(dispatcher, reason)
      DispatcherEventHandler::Handler::Changed.handle(dispatcher, objs, reason)
    end

    it "should handle changed technologies" do
      obj = Factory.create(:technology)
      lambda do
        DispatcherEventHandler::Handler::Changed.handle(dispatcher, obj, reason)
      end.should_not raise_error
    end

    it "should handle changed construction queue" do
      planet = Factory.create(:planet_with_player)
      constructor = Factory.create(:b_constructor_test, :planet => planet)
      obj = Event::ConstructionQueue.new(constructor.id)

      dispatcher.should_receive(:push_to_player).with(
        planet.player_id,
        ConstructionQueuesController::ACTION_INDEX,
        {'constructor_id' => constructor.id},
        Dispatcher::PushFilter.ss_object(planet.id)
      )

      DispatcherEventHandler::Handler::Changed.handle(dispatcher, obj, reason)
    end

    describe "changed player" do
      it "should handle it" do
        obj = Factory.create :player
        dispatcher.stub!(:connected?).with(obj.id).and_return(true)
        dispatcher.should_receive(:update_player).with(obj)
        dispatcher.should_receive(:push_to_player).with(
          obj.id, PlayersController::ACTION_SHOW
        )
        DispatcherEventHandler::Handler::Changed.handle(dispatcher, obj, reason)
      end

      it "should not update player in dispatcher if it's not connected" do
        obj = Factory.create :player
        dispatcher.stub!(:connected?).with(obj.id).and_return(false)
        dispatcher.should_not_receive(:update_player)
        DispatcherEventHandler::Handler::Changed.handle(dispatcher, obj, reason)
      end
    end

    describe "planet owner change" do
      def create(has_old, has_new)
        old = has_old ? Factory.create(:player) : nil
        new = has_new ? Factory.create(:player) : nil
        planet = Factory.create(:planet, :player => old)
        planet.player = new

        [planet, old, new]
      end

      [[true, true], [true, false], [false, true]].each do |has_old, has_new|
        old_desc = has_old ? "old player" : "NPC"
        new_desc = has_new ? "new player" : "NPC"

        it "should handle #{old_desc} -> #{new_desc} change" do
          planet, old, new = create(has_old, has_new)

          dispatcher.should_receive(:push_to_player).
            with(old.id, PlanetsController::ACTION_PLAYER_INDEX) if has_old
          dispatcher.should_receive(:push_to_player).
            with(new.id, PlanetsController::ACTION_PLAYER_INDEX) if has_new

          DispatcherEventHandler::Handler::Changed.
            handle(dispatcher, planet, EventBroker::REASON_OWNER_CHANGED)
        end

        it "should handle object part of #{old_desc} -> #{new_desc} change" do
          planet, old, new = create(has_old, has_new)

          dispatcher.stub!(:push_to_player)
          test_object_change(
            dispatcher, EventBroker::REASON_OWNER_CHANGED, [planet]
          )

          DispatcherEventHandler::Handler::Changed.
            handle(dispatcher, planet, EventBroker::REASON_OWNER_CHANGED)
        end

        describe "if reason is not owner changed" do
          it "should not handle #{old_desc} -> #{new_desc} change" do
            planet, old, new = create(has_old, has_new)

            dispatcher.should_not_receive(:push_to_player).
              with(old.id, PlanetsController::ACTION_PLAYER_INDEX) if has_old
            dispatcher.should_not_receive(:push_to_player).
              with(new.id, PlanetsController::ACTION_PLAYER_INDEX) if has_new

            DispatcherEventHandler::Handler::Changed.
              handle(dispatcher, planet, reason)
          end
        end
      end
    end

    it "should dispatch to player if changed units are in buildings" do
      planet = Factory.create(:planet_with_player)
      unit = Factory.create(:unit,
        :location => Factory.create(:b_npc_solar_plant, :planet => planet)
      )
      objs = [unit]
      dispatcher.should_receive(:push_to_player).with(
        planet.player_id, ObjectsController::ACTION_UPDATED,
        {'objects' => objs, 'reason' => reason},
        Dispatcher::PushFilter.ss_object(planet.id)
      )
      DispatcherEventHandler::Handler::Changed.
        handle(dispatcher, objs, reason)
    end

    it "should handle Event::StatusChange" do
      event = Event::StatusChange.new({1 => [2, 3], 10 => [20, 1]})

      event.statuses.each do |player_id, changes|
        dispatcher.should_receive(:push_to_player).with(
          player_id, PlayersController::ACTION_STATUS_CHANGE,
          {'changes' => changes}, nil
        )
        dispatcher.should_receive(:push_to_player).
          with(player_id, RoutesController::ACTION_INDEX)
      end

      DispatcherEventHandler::Handler::Changed.handle(dispatcher, event, reason)
    end
  end
end

