require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe DispatcherEventHandler::LocationResolver do
  describe ".resolve" do
    it "should resolve Location::GALAXY" do
      galaxy = Factory.create(:galaxy)
      point = GalaxyPoint.new(galaxy.id, 0, 0)
      unit = Factory.create(:unit, :location => point)
      Factory.create(:fge_player, :player => unit.player, :x => -5, :y => -5,
        :x_end => 5, :y_end => 5)
      DispatcherEventHandler::LocationResolver.resolve(unit.location).
        should == [
          FowGalaxyEntry.observer_player_ids(point.id, point.x, point.y),
          nil
        ]
    end

    it "should resolve Location::SOLAR_SYSTEM" do
      ss = Factory.create(:solar_system)
      point = SolarSystemPoint.new(ss.id, 0, 0)
      unit = Factory.create(:unit, :location => point)
      Factory.create(:fse_player, :player => unit.player, :solar_system => ss)
      DispatcherEventHandler::LocationResolver.resolve(unit.location).
        should == [
          FowSsEntry.observer_player_ids(point.id),
          Dispatcher::PushFilter.solar_system(point.id)
        ]
    end

    it "should resolve Location::SS_OBJECT" do
      planet = Factory.create(:planet_with_player)
      unit = Factory.create(:unit, :location => planet)
      DispatcherEventHandler::LocationResolver.resolve(unit.location).
        should == [
          planet.observer_player_ids,
          Dispatcher::PushFilter.ss_object(planet.id)
        ]
    end

    it "should resolve Location::UNIT" do
      planet = Factory.create(:planet_with_player)
      transporter = Factory.create(:unit, :location => planet)
      unit = Factory.create(:unit, :location => transporter)
      DispatcherEventHandler::LocationResolver.resolve(unit.location).should == [
        planet.observer_player_ids,
          Dispatcher::PushFilter.ss_object(planet.id)
      ]
    end
  end

  describe ".resolve_movement" do
    it "should return unmodified values if location is not an galaxy point" do
      point = SolarSystemPoint.new(1, 0, 0)

      DispatcherEventHandler::LocationResolver.should_receive(:resolve).
        with(point).and_return([:player_ids, :filter])

      DispatcherEventHandler::LocationResolver.
        resolve_movement(point, [1,2,3]).should == [:player_ids, :filter]
    end

    it "should add friendly ids if location is galaxy point" do
      point = GalaxyPoint.new(1, 0, 0)

      DispatcherEventHandler::LocationResolver.should_receive(:resolve).
        with(point).and_return([[1], :filter])

      DispatcherEventHandler::LocationResolver.
        resolve_movement(point, [1,2,3]).should == [[1,2,3], :filter]
    end
  end
end

