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
end