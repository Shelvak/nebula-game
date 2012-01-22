require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper.rb')
)

describe DispatcherEventHandler::Handler::Created do
  include DispatcherEventHandlerObjectHelpers

  let(:dispatcher) { mock(Dispatcher) }
  let(:reason) { :reason }

  describe ".handle" do
    it "should handle created objects" do
      objs = test_object_creation(dispatcher, reason)
      DispatcherEventHandler::Handler::Created.handle(dispatcher, objs, reason)
    end

    it "should handle Event::PlanetObserversChange" do
      event = Event::PlanetObserversChange.new(10, [1,2,3,4])
      filter = Dispatcher::PushFilter.ss_object(event.planet_id)

      event.non_observer_ids.each do |player_id|
        dispatcher.should_receive(:push_to_player).with(
          player_id, PlanetsController::ACTION_UNSET_CURRENT,
          {}, filter
        )
      end

      DispatcherEventHandler::Handler::Created.handle(dispatcher, event, reason)
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
        dispatcher.should_receive(:push_to_player).with(
          player.id, GalaxiesController::ACTION_APOCALYPSE,
          {'start' => galaxy.apocalypse_start}, nil
        )
      end

      event = Event::ApocalypseStart.new(galaxy.id, galaxy.apocalypse_start)
      DispatcherEventHandler::Handler::Created.handle(dispatcher, event, reason)
    end
  end
end

