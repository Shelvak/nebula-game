require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe GalaxyPoint do
  describe "constructor" do
    it "should require x to be Fixnum" do
      lambda do
        GalaxyPoint.new(Factory.create(:galaxy).id, nil, 12)
      end.should raise_error(ArgumentError)
    end

    it "should require y to be Fixnum" do
      lambda do
        GalaxyPoint.new(Factory.create(:galaxy).id, 0, nil)
      end.should raise_error(ArgumentError)
    end
  end

  describe "galaxy delegation" do
    it "should delegate galaxy" do
      model = Factory.create :galaxy
      GalaxyPoint.new(model.id, 0, 12).galaxy.should == model
    end

    it "should delegate galaxy_id" do
      GalaxyPoint.new(10, 0, 12).galaxy_id.should == 10
    end
  end

  describe "#solar_system" do
    it "should return nil" do
      GalaxyPoint.new(10, 20, 30).solar_system.should be_nil
    end
  end

  describe "#solar_system_id" do
    it "should return nil" do
      GalaxyPoint.new(10, 20, 30).solar_system_id.should be_nil
    end
  end

  describe "#route_attrs" do
    it "should return Hash" do
      id = 10
      x = 0
      y = 12
      GalaxyPoint.new(id, x, y).route_attrs.should == {
        :id => id, :type => Location::GALAXY, :x => x, :y => y
      }
    end
  end

  describe "#==" do
    it "should compare attributes" do
      GalaxyPoint.new(1, 2, 3).should == GalaxyPoint.new(1, 2, 3)
    end
  end
end
