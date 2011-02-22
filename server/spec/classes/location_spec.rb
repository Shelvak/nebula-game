require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Location do
  describe ".fighting_player_ids" do
    before(:each) do
      @planet = Factory.create :planet_with_player
      @location = @planet.location
    end

    it "should return distinct ids" do
      player = Factory.create(:player)
      Factory.create(:unit, :location => @location, :player => player)
      Factory.create(:unit, :location => @location, :player => player)

      Location.fighting_player_ids(@location).should == [player.id]
    end

    it "should include nils" do
      player = Factory.create(:player)
      Factory.create(:unit, :location => @location, :player => nil)

      Location.fighting_player_ids(@location).should == [nil]
    end

    it "should include planet owner if it has shooting buildings" do
      Factory.create!(:b_vulcan, :planet => @planet)
      Location.fighting_player_ids(@location).should == [@planet.player_id]
    end
  end

  describe ".find_by_attrs" do
    it "should return GalaxyPoint when in galaxy" do
      Location.find_by_attrs(:location_type => Location::GALAXY,
        :location_id => 20, :location_x => 3, :location_y => 10
      ).should == GalaxyPoint.new(20, 3, 10)
    end

    it "should return SolarSystemPoint when in solar system" do
      Location.find_by_attrs(:location_type => Location::SOLAR_SYSTEM,
        :location_id => 20, :location_x => 3, :location_y => 90
      ).should == SolarSystemPoint.new(20, 3, 90)
    end

    it "should return Planet when in planet" do
      planet = Factory.create(:planet)
      Location.find_by_attrs(planet.location_attrs).should == planet
    end

    it "should return Unit when in unit" do
      unit = Factory.create(:unit)
      Location.find_by_attrs(unit.location_attrs).should == unit
    end

    it "should return Building when in building" do
      building = Factory.create(:building)
      Location.find_by_attrs(building.location_attrs).should == building
    end
  end

  describe ".visible?" do
    it "should return true if galaxy point is visible" do
      player = Factory.create(:player)
      FowGalaxyEntry.increase(Rectangle.new(0, 0, 0, 0), player)
      Location.visible?(player,
        GalaxyPoint.new(player.galaxy_id, 0, 0)
      ).should be_true
    end

    it "should return false if galaxy point is not visible" do
      player = Factory.create(:player)
      Location.visible?(player,
        GalaxyPoint.new(player.galaxy_id, 0, 0)
      ).should be_false
    end

    it "should return true if ss point is visible" do
      player = Factory.create(:player)
      solar_system = Factory.create(:solar_system)
      FowSsEntry.increase(solar_system.id, player)
      Location.visible?(player,
        SolarSystemPoint.new(solar_system.id, 1, 0)
      ).should be_true
    end

    it "should return false if ss point is not visible" do
      player = Factory.create(:player)
      solar_system = Factory.create(:solar_system)
      Location.visible?(player,
        SolarSystemPoint.new(solar_system.id, 1, 0)
      ).should be_false
    end

    it "should return true if planet is visible" do
      player = Factory.create(:player)
      planet = Factory.create(:planet)
      FowSsEntry.increase(planet.solar_system_id, player)
      Location.visible?(player, planet).should be_true
    end

    it "should return false if planet is not visible" do
      player = Factory.create(:player)
      planet = Factory.create(:planet)
      Location.visible?(player, planet).should be_false
    end

    describe "battleground" do
      before(:each) do
        @battleground = Factory.create(:battleground)
        @player = Factory.create(:player, :galaxy => @battleground.galaxy)
        @wormhole = Factory.create(:wormhole,
          :galaxy => @battleground.galaxy)
      end

      it "should return true if wormhole is visible" do
        FowSsEntry.increase(@wormhole.id, @player)
        Location.visible?(@player,
          SolarSystemPoint.new(@battleground.id, 1, 0)
        ).should be_true
      end

      it "should return false if wormhole is not visible" do
        Location.visible?(@player,
          SolarSystemPoint.new(@battleground.id, 1, 0)
        ).should be_false
      end

      describe "planet" do
        before(:each) do
          @planet = Factory.create(:planet, :solar_system => @battleground)
        end

        it "should return true if wormhole is visible" do
          FowSsEntry.increase(@planet.solar_system_id, @player)
          Location.visible?(@player, @planet).should be_true
        end

        it "should return false if wormhole is not visible" do
          Location.visible?(@player, @planet).should be_false
        end
      end
    end

    it "should raise error if it doesn't know how to handle it" do
      lambda do
        Location.visible?(Factory.create(:player), nil)
      end.should raise_error(ArgumentError)
    end
  end

  describe "#location_attrs" do
    [
      GalaxyPoint.new(1, 2, 3),
      SolarSystemPoint.new(1, 2, 90)
    ].each do |object|
      describe object.class do
        it "should return #route_attrs with 'location_' prefix" do
          object.location_attrs.should == object.route_attrs('location_')
        end
      end
    end

    describe SsObject do
      it "should return hash" do
        planet = Factory.create(:planet)
        planet.location_attrs.should == {
          :location_id => planet.id,
          :location_type => Location::SS_OBJECT,
          :location_x => nil,
          :location_y => nil
        }
      end
    end
  end
end