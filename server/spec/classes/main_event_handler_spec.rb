require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe MainEventHandler do
  it "should register to EventBroker" do
    EventBroker.should_receive(:register).with(
      an_instance_of(MainEventHandler))
    MainEventHandler.new
  end

  describe "events" do
    before(:all) do
      @handler = MainEventHandler.new

      # Don't get other events, only ones we submit
      EventBroker.unregister(@handler)
    end

    describe "movement" do
      before(:all) do
        @solar_system = Factory.create(:solar_system)
      end

      it "should increase fow ss entry if entering ss" do
        current = SolarSystemPoint.new(@solar_system.id, 0, 0)
        route = Factory.create(:route,
          :current => current.to_client_location,
          :cached_units => {
            "Mule" => 3,
            "Crow" => 5
          }
        )
        previous_location = GalaxyPoint.new(@solar_system.galaxy_id, 0, 0)
        current_hop = Factory.create(:route_hop, :route => route,
          :location => current)

        FowSsEntry.should_receive(:increase).with(current.id,
          route.player, 8)
        @handler.fire(
          MovementEvent.new(route, previous_location, current_hop, nil),
          EventBroker::MOVEMENT, EventBroker::REASON_BETWEEN_ZONES
        )
      end

      it "should decrease fow ss entry if leaving ss" do
        current = GalaxyPoint.new(@solar_system.galaxy_id, 0, 0)
        route = Factory.create(:route,
          :current => current.to_client_location,
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
        @handler.fire(
          MovementEvent.new(route, previous_location, current_hop, nil),
          EventBroker::MOVEMENT, EventBroker::REASON_BETWEEN_ZONES
        )
      end
    end
  end
end