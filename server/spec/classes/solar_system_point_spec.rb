require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe SolarSystemPoint do
  describe ".angle_valid?" do
    it "should return true @ 0,0" do
      SolarSystemPoint.angle_valid?(0, 0).should be_true
    end

    it "should return true @ 0,90" do
      SolarSystemPoint.angle_valid?(0, 90).should be_true
    end

    it "should return true @ 1,45" do
      SolarSystemPoint.angle_valid?(1, 45).should be_true
    end

    it "should return false @ 0,46" do
      SolarSystemPoint.angle_valid?(0, 46).should be_false
    end
  end

  describe "galaxy delegation" do
    it "should delegate galaxy" do
      model = Factory.create :solar_system
      SolarSystemPoint.new(model.id, 1, 45).galaxy.should == model.galaxy
    end

    it "should delegate galaxy_id" do
      model = Factory.create :solar_system
      SolarSystemPoint.new(model.id, 1, 45).galaxy_id.should \
        == model.galaxy_id
    end
  end

  describe "solar_system" do
    before(:all) do
      @solar_system = Factory.create :solar_system
    end

    it "should return SolarSystem in which the point is" do
      SolarSystemPoint.new(@solar_system.id, 1, 0).solar_system.should \
        == @solar_system
    end

    it "should return SolarSystem ID in which the point is" do
      SolarSystemPoint.new(@solar_system.id, 1, 0).solar_system_id.should \
        == @solar_system.id
    end
  end

  describe "constructor" do
    it "should not accept position < 0" do
      lambda do
        SolarSystemPoint.new(10, -1, 0)
      end.should raise_error(ArgumentError)
    end

    it "should not accept angle < 0" do
      lambda do
        SolarSystemPoint.new(10, 1, -1)
      end.should raise_error(ArgumentError)
    end

    it "should not accept angle >= 360" do
      lambda do
        SolarSystemPoint.new(10, 1, 360)
      end.should raise_error(ArgumentError)
    end

    it "should not accept invalid angle" do
      lambda do
        SolarSystemPoint.new(10, 1, 46)
      end.should raise_error(ArgumentError)
    end
  end

  describe "#==" do
    it "should compare attributes" do
      SolarSystemPoint.new(1, 1, 45).should == SolarSystemPoint.new(
        1, 1, 45)
    end
  end

  describe "#route_attrs" do
    it "should return Hash" do
      id = 10
      position = 1
      angle = 45
      SolarSystemPoint.new(id, position, angle).route_attrs.should == {
        :id => id,
        :type => Location::SOLAR_SYSTEM,
        :x => position,
        :y => angle
      }
    end
  end

  describe "#client_location" do
    it "should return ClientLocation" do
      id = 10
      position = 1
      angle = 90
      SolarSystemPoint.new(
        id, position, angle
      ).client_location.should == ClientLocation.new(id,
        Location::SOLAR_SYSTEM, position, angle, nil, nil, nil)
    end
  end
end