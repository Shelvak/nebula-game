require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe LocationLock do
  describe ".with_lock" do
    planet = Factory.create(:planet)
    ss = planet.solar_system
    galaxy = ss.galaxy

    [
      [
        "galaxy",
        GalaxyPoint.new(galaxy.id, -10, -20),
        GalaxyPoint.new(galaxy.id, -10, -25),
        {location_galaxy_id: galaxy.id, location_x: -10, location_y: -20}
      ],
      [
        "solar system",
        SolarSystemPoint.new(ss.id, 1, 180),
        SolarSystemPoint.new(ss.id, 2, 180),
        {location_solar_system_id: ss.id, location_x: 1, location_y: 180}
      ],
      [
        "planet",
        LocationPoint.planet(planet.id),
        LocationPoint.planet(Factory.create(:planet).id),
        {location_ss_object_id: planet.id}
      ],

    ].each do |type, point1, point2, conditions|
      describe "#{type} point" do
        it "should acquire the lock before entering the block" do
          LocationLock.where(conditions).should_not exist
          LocationLock.with_lock(point1) do
            LocationLock.where(conditions).should exist
          end
        end

        it "should clean up the lock after exiting the block" do
          LocationLock.with_lock(point1) do
            LocationLock.where(conditions).should exist
          end
          LocationLock.where(conditions).should_not exist
        end

        it "should only clean up appropriate locks" do
          LocationLock.where(conditions).should_not exist
          LocationLock.with_lock(point1) do
            LocationLock.where(conditions).should exist
            LocationLock.with_lock(point2) { }
            LocationLock.where(conditions).should exist
          end
          LocationLock.where(conditions).should_not exist
        end
      end
    end
  end
end