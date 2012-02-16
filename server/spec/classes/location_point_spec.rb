require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe LocationPoint do
  describe "constructor" do
    it "should require id to be Fixnum" do
      lambda do
        LocationPoint.new(nil, Location::GALAXY, 0, 0)
      end.should raise_error(ArgumentError)
    end

    it "should require type to be Fixnum" do
      lambda do
        LocationPoint.new(1, nil, 0, 0)
      end.should raise_error(ArgumentError)
    end
  end

  describe "#object" do
    it "should dispatch to Location#find_by_attrs" do
      Location.should_receive(:find_by_attrs).with(
        :location_id => 1,
        :location_type => Location::GALAXY,
        :location_x => 2,
        :location_y => 3
      )
      LocationPoint.new(1, Location::GALAXY, 2, 3).object
    end
  end

  describe "#client_location" do
    describe "when galaxy" do
      it "should return ClientLocation" do
        id = 10
        x = 0
        y = 12
        LocationPoint.new(id, Location::GALAXY, x, y).client_location.
          should == ClientLocation.new(id, Location::GALAXY, x, y)
      end
    end

    describe "when solar system" do
      it "should return ClientLocation" do
        ss = Factory.create(:solar_system)
        id = ss.id
        position = 1
        angle = 90
        LocationPoint.new(
          id, Location::SOLAR_SYSTEM, position, angle
        ).client_location.should == ClientLocation.new(
          id, Location::SOLAR_SYSTEM, position, angle
        )
      end
    end

    describe "when ss object" do
      it "should return ClientLocation" do
        position = 2
        angle = 90
        planet = Factory.create(
          :planet_with_player, :position => position, :angle => angle
        )
        planet.location_point.client_location.should == ClientLocation.new(
          planet.id, Location::SS_OBJECT, planet.position, planet.angle
        )
      end
    end
  end
end