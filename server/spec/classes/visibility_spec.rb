require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe Visibility do
  describe ".track_location_changes" do
    
  end

  describe ".track_movement_changes" do
    galaxy_location1 = GalaxyPoint.new(1, 0, 0)
    galaxy_location2 = GalaxyPoint.new(1, 1, 0)
    ss_location1 = SolarSystemPoint.new(10, 0, 0)
    ss_location2 = SolarSystemPoint.new(15, 0, 0)
    planet_location = LocationPoint.planet(20)

    [
      [galaxy_location1, galaxy_location2, nil],
      [galaxy_location1, ss_location1, ss_location1],
      [ss_location1, planet_location, planet_location],
      [planet_location, ss_location1, planet_location],
      [ss_location1, ss_location2, ss_location1],
    ].each do |source, target, expected|
      describe "when going from #{source} to #{target}" do
        if expected.nil?
          it "should just call block" do
            executed = false
            Visibility.track_movement_changes(source, target) do
              executed = true
            end
            executed.should be_true
          end
        else
          it "should pass #{expected} to .track_location_changes" do
            block = proc { }
            Visibility.should_receive(:track_location_changes).
              with(expected, &block)
            Visibility.track_movement_changes(source, target, &block)
          end
        end
      end
    end
  end
end