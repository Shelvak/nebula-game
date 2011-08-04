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

  describe "#observer_player_ids" do
    before(:all) do
      @unit_player_ids = [1,2,3]
      @fge_player_ids = [3,4,5]

      point = GalaxyPoint.new(1, 0, 0)
      Unit.stub!(:player_ids_in_location).with(point).and_return(
        @unit_player_ids)
      FowGalaxyEntry.stub!(:observer_player_ids).with(
        point.id, point.x, point.y).and_return(@fge_player_ids)
      @result = point.observer_player_ids
    end

    it "should include player ids from units" do
      (@result & @unit_player_ids).should_not be_blank
    end

    it "should include player ids from fow entries" do
      (@result & @fge_player_ids).should_not be_blank
    end

    it "should not contain duplicate entries" do
      @result.should == @result.uniq
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

  describe "#client_location" do
    it "should return ClientLocation" do
      id = 10
      x = 0
      y = 12
      GalaxyPoint.new(id, x, y).client_location.should == \
        ClientLocation.new(id, Location::GALAXY, x, y, nil, nil, nil, nil, 
        nil)
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
