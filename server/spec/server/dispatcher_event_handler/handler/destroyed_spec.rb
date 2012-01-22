require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper.rb')
)

describe DispatcherEventHandler::Handler::Destroyed do
  include DispatcherEventHandlerObjectHelpers

  let(:dispatcher) { mock(Dispatcher) }
  let(:reason) { :reason }

  describe ".handle" do
    it "should handle destroyed objects" do
      objs = test_object_destruction(dispatcher, reason)
      DispatcherEventHandler::Handler::Destroyed.
        handle(dispatcher, objs, reason)
    end

    it "should dispatch to player if destroyed units are in buildings" do
      planet = Factory.create(:planet_with_player)
      unit = Factory.create(:unit,
        :location => Factory.create(:b_npc_solar_plant, :planet => planet))
      objs = [unit]
      dispatcher.should_receive(:push_to_player).with(
        planet.player_id, ObjectsController::ACTION_DESTROYED,
        {'objects' => objs, 'reason' => reason},
        Dispatcher::PushFilter.ss_object(planet.id)
      )
      DispatcherEventHandler::Handler::Destroyed.
        handle(dispatcher, objs, reason)
    end
  end
end

