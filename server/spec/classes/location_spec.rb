require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Location do
  describe ".combat_player_ids" do
    before(:each) do
      @player = Factory.create(:player, :planets_count => 2)
      @planet = Factory.create(:planet, :player => @player)
      @location = @planet.location
    end
    
    it "should return distinct array" do
      player_ids = Location.combat_player_ids(@location)
      player_ids.should == player_ids.uniq
    end

    it "should include players from units" do
      player = Factory.create(:player)
      returns = [1,2,3,4,5]
      Unit.should_receive(:player_ids_in_location).with(@location, true).
        and_return(returns)

      (Location.combat_player_ids(@location) & returns).should_not be_blank
    end

    it "should include nils" do
      Factory.create(:unit_built, :location => @location, :player => nil)

      Location.combat_player_ids(@location).should include(nil)
    end

    it "should include planet owner" do
      Location.combat_player_ids(@location).should include(@planet.player_id)
    end
    
    describe "NPC planet owner" do
      before(:each) do
        @planet.player = nil
        @planet.save!
      end
    
      it "should not include it" do
        Location.combat_player_ids(@location).should_not include(nil)
      end

      it "should include it if planet has combat buildings" do
        Factory.create!(:b_thunder, opts_active + {:planet => @planet})
        Location.combat_player_ids(@location).should include(nil)
      end

      it "should not include it if planet has non-active combat buildings" do
        Factory.create!(:b_thunder, opts_inactive + {:planet => @planet})
        Location.combat_player_ids(@location).should_not include(nil)
      end
    end
  end

  describe ".find_by_attrs" do
    it "should return GalaxyPoint when in galaxy" do
      Location.find_by_attrs(
        :location_galaxy_id => 20, :location_x => 3, :location_y => 10
      ).should == GalaxyPoint.new(20, 3, 10)
    end

    it "should return SolarSystemPoint when in solar system" do
      Location.find_by_attrs(
        :location_solar_system_id => 20, :location_x => 3, :location_y => 90
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

  describe ".id_and_type_from_row" do
    it "should be able to change prefix" do
      Location.id_and_type_from_row({:ss_object_id => 20}, "").should ==
        Location.id_and_type_from_row(:location_ss_object_id => 20)
    end

    it "should symbolize keys" do
      Location.id_and_type_from_row("location_ss_object_id" => 20).should ==
        Location.id_and_type_from_row(:location_ss_object_id => 20)
    end

    it "should work for galaxy" do
      Location.id_and_type_from_row(
        :location_galaxy_id => 20, :location_x => 3, :location_y => 10
      ).should == [20, Location::GALAXY]
    end

    it "should work for solar system" do
      Location.id_and_type_from_row(
        :location_solar_system_id => 20, :location_x => 3, :location_y => 90
      ).should == [20, Location::SOLAR_SYSTEM]
    end

    it "should work for ss object" do
      Location.id_and_type_from_row(
        :location_ss_object_id => 20, :location_x => nil, :location_y => nil
      ).should == [20, Location::SS_OBJECT]
    end

    it "should work for unit" do
      Location.id_and_type_from_row(
        :location_unit_id => 20, :location_x => nil, :location_y => nil
      ).should == [20, Location::UNIT]
    end

    it "should work for building" do
      Location.id_and_type_from_row(
        :location_building_id => 20, :location_x => nil, :location_y => nil
      ).should == [20, Location::BUILDING]
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
      SolarSystem.should_receive(:find_if_visible_for).with(solar_system.id,
        player).and_return(solar_system)
      Location.visible?(player,
        SolarSystemPoint.new(solar_system.id, 1, 0)
      ).should be_true
    end

    it "should return false if ss point is not visible" do
      player = Factory.create(:player)
      solar_system = Factory.create(:solar_system)
      SolarSystem.should_receive(:find_if_visible_for).with(solar_system.id,
        player).and_raise(ActiveRecord::RecordNotFound)
      Location.visible?(player,
        SolarSystemPoint.new(solar_system.id, 1, 0)
      ).should be_false
    end

    it "should return true if planet is visible" do
      player = Factory.create(:player)
      planet = Factory.create(:planet)
      SolarSystem.should_receive(:find_if_visible_for).with(
        planet.solar_system.id,
        player).and_return(planet.solar_system)
      Location.visible?(player, planet).should be_true
    end

    it "should return false if planet is not visible" do
      player = Factory.create(:player)
      planet = Factory.create(:planet)
      SolarSystem.should_receive(:find_if_visible_for).with(
        planet.solar_system.id,
        player).and_raise(ActiveRecord::RecordNotFound)
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
          FowSsEntry.increase(@wormhole.id, @player)
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
        planet.location_attrs.should == {:location_ss_object_id => planet.id}
      end
    end
  end
end