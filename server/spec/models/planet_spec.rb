require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Planet do
  describe "#observer_player_ids" do
    before(:all) do
      @alliance = Factory.create :alliance
      @player = Factory.create :player, :alliance => @alliance
      @ally = Factory.create :player, :alliance => @alliance
      @enemy_with_units = Factory.create :player
      @enemy = Factory.create :player

      @planet = Factory.create :planet, :player => @player
      Factory.create :unit, :location_type => Location::PLANET,
        :location_id => @planet.id, :player => @enemy_with_units

      @result = @planet.observer_player_ids
    end

    it "should include planet owner" do
      @result.should include(@player.id)
    end

    it "should include alliance members" do
      @result.should include(@ally.id)
    end

    it "should include other players that have units there" do
      @result.should include(@enemy_with_units.id)
    end

    it "should work without owning player" do
      @planet.player = nil
      @planet.save!
      @planet.observer_player_ids.should be_instance_of(Array)
    end

    it "should not include players that do not have units there" do
      @result.should_not include(@enemy.id)
    end
  end

  describe "galaxy delegation" do
    it "should delegate galaxy" do
      model = Factory.create :planet
      model.galaxy.should == model.solar_system.galaxy
    end

    it "should delegate galaxy_id" do
      model = Factory.create :planet
      model.galaxy_id.should == model.solar_system.galaxy_id
    end
  end

  describe ".buildings" do
    describe ".shooting" do
      it "should return shooting buildings of that planet" do
        planet = Factory.create :planet
        shooting = Factory.create :building, :planet => planet
        Factory.create :b_solar_plant, :planet => planet,
          :x => 10, :y => 10

        with_config_values('buildings.test_building.guns' => [:aa]) do
          planet.buildings.shooting.should == [shooting]
        end
      end
    end
  end

  describe "#units" do
    it "should find planet units" do
      planet = Factory.create :planet_with_player
      player = planet.player
      unit1 = Factory.create :unit, :location => planet, :player => player
      unit2 = Factory.create :unit, :player => player
      unit3 = Factory.create :unit, :location => planet, :player => player

      planet.units.should == [unit1, unit3]
    end

    it "should not find npc units" do
      planet = Factory.create :planet_with_player
      player = planet.player
      unit1 = Factory.create :unit, :location => planet, :player => nil
      unit2 = Factory.create :unit, :location => planet, :player => nil
      unit3 = Factory.create :unit, :location => planet, :player => player

      planet.units.should == [unit3]
    end

    it "should not find units in buildings" do
      planet = Factory.create :planet_with_player
      player = planet.player

      unit1 = Factory.create :unit, :location => planet,
        :player => player
      unit2 = Factory.create :unit, 
        :location => Factory.create(:building, :x => 10, :y => 20),
        :player => player
      unit3 = Factory.create :unit, :location => planet,
        :player => player

      planet.units.should == [unit1, unit3]
    end
  end

  describe "#route_attrs" do
    it "should return Hash" do
      position = 2
      angle = 90
      planet = Factory.create(:planet, :position => position,
        :angle => angle)
      planet.route_attrs.should == {
        :id => planet.id,
        :type => Location::PLANET,
        :x => planet.position,
        :y => planet.angle
      }
    end
  end

  describe "#client_location" do
    it "should return ClientLocation" do
      position = 2
      angle = 90
      planet = Factory.create(:planet, :position => position,
        :angle => angle)
      planet.client_location.should == ClientLocation.new(planet.id,
        Location::PLANET, position, angle, planet.name, planet.variation,
        planet.solar_system_id)
    end
  end

  describe ".find_for_player!" do
    it "should raise ActiveRecord::RecordNotFound if not found" do
      planet = Factory.create :planet
      lambda do
        Planet.find_for_player!(planet.id, 0)
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should return Planet if found" do
      planet = Factory.create :planet
      Planet.find_for_player!(planet.id, planet.player_id).should == planet
    end
  end

  describe ".find_all_for_player" do
    it "should return player planets" do
      planet0 = Factory.create :planet_with_player
      planet1 = Factory.create :planet_with_player
      planet2 = Factory.create :planet_with_player,
        :player => planet1.player
      planet3 = Factory.create :planet_with_player

      Planet.for_player(planet1.player_id).all.should == [
        planet1, planet2
      ]
    end
  end

  describe ".size_from_dimensions" do
    it "should return value in type size range" do
      Planet.size_from_dimensions('regular', 30, 40
        ).should be_in_config_range('planet.size')
    end
    
    it "should return random value if type is homeworld" do
      CONFIG.should_receive(:hashrand).with('planet.size'
        ).and_return(10)
      Planet.size_from_dimensions('homeworld', 30, 30)
    end

    it "should return random value if width is nil" do
      CONFIG.should_receive(:hashrand).with('planet.size'
        ).and_return(10)
      Planet.size_from_dimensions('regular', nil, 30)
    end

    it "should return random value if height is nil" do
      CONFIG.should_receive(:hashrand).with('planet.size'
        ).and_return(10)
      Planet.size_from_dimensions('regular', 30, nil)
    end
  end

  describe "#to_json" do
    before(:all) do
      @model = Factory.create(:planet)
    end

    @required_fields = %w{planet_class}
    @ommited_fields = %w{type}
    it_should_behave_like "to json"
    
    it "should include player if it's available" do
      model = Factory.create(:planet_with_player)
      model.to_json.should include('"player":' + model.player.to_json)
    end
  end

  describe "resources entry" do
    it "should create one for planet" do
      Factory.create(:planet).resources_entry.should_not be_nil
    end

    it "should set `last_update` if assigned a player and last_update IS NULL" do
      model = Factory.create(:planet)
      re = model.resources_entry
      re.last_update = nil
      re.save!

      model.player = Factory.create(:player)
      model.save!
      re.reload
      re.last_update.drop_usec.should == Time.now.drop_usec
    end
  end

  it "should not allow creating two planets in same position in same SS" do
    planet = Factory.create :planet, :position => 3
    Factory.build(:planet, :position => planet.position,
      :solar_system => planet.solar_system).should_not be_valid
  end

  it "should set angle if specified" do
    value = 133
    model = Factory.create :planet, :angle => value
    model.angle.should eql(value)
  end

  it "should have random angle if not specified" do
    model = Factory.create :planet, :angle => nil
    model.angle.should be_greater_or_equal_to(0)
    model.angle.should be_lesser_than(360)
  end

  it "should assign size by area" do
    model = Factory.create :p_regular
    model.size.should == Planet.size_from_dimensions(
      model.type.underscore, model.width, model.height)
  end

  describe "player changing" do
    it "should call FowSsEntry.change_planet_owner" do
      model = Factory.create :planet
      FowSsEntry.should_receive(:change_planet_owner).with(model)
      model.player = Factory.create :player
      model.save!
    end

    it "should fire event" do
      model = Factory.create :planet
      model.player = Factory.create :player
      
      should_fire_event(model, EventBroker::CHANGED,
      EventBroker::REASON_OWNER_CHANGED) do
        model.save!
      end
    end
  end

  [:regular].each do |type|
    [:width, :height].each do |attr|
      it "should set #{attr} if specified for #{type}" do
        value = 100
        model = Factory.create "p_#{type}", attr => value
        model.send(attr).should eql(value)
      end

      it "should call Map.dimensions_for_area('#{type}')" do
        value = 100
        Map.should_receive(:dimensions_for_area).with(type)
        model = Factory.create "p_#{type}", attr => nil
      end

      it "should not leave #{attr} nil if not specified for #{type}" do
        model = Factory.create "p_#{type}"
        model.send(attr).should_not be_nil
      end
    end
  end

  describe "#unassigned?" do
    it "should return true if player_id.nil?" do
      Planet.new(:player_id => nil).unassigned?.should be_true
    end
    
    it "should return false if it has player_id" do
      Planet.new(:player_id => 1).unassigned?.should be_false
    end
  end
end