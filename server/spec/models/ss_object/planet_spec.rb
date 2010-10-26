require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe SsObject::Planet do
  describe "#observer_player_ids" do
    before(:all) do
      @alliance = Factory.create :alliance
      @player = Factory.create :player, :alliance => @alliance
      @ally = Factory.create :player, :alliance => @alliance
      @enemy_with_units = Factory.create :player
      @enemy = Factory.create :player

      @planet = Factory.create :planet, :player => @player
      Factory.create :unit, :location_type => Location::SS_OBJECT,
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

  describe "#as_json" do
    before(:all) do
      @model = Factory.create(:planet)
    end

    it "should include player if it's available" do
      model = Factory.create(:planet_with_player)
      model.as_json[:player].should == model.player
    end

    describe "without options" do
      before(:all) do
        @options = nil
      end

      @required_fields = %w{name}
      @ommited_fields = %w{width height metal metal_rate metal_storage
        energy energy_rate energy_storage
        zetium zetium_rate zetium_storage
        last_resources_update energy_diminish_registered}
      it_should_behave_like "to json"
    end
    
    describe "with :view" do
      before(:all) do
        @options = {:view => true}
      end

      @required_fields = %w{width height}
      it_should_behave_like "to json"
    end

    describe "with :resources" do
      before(:all) do
        @options = {:resources => true}
      end

      @required_fields = %w{metal metal_rate metal_storage
        energy energy_rate energy_storage
        zetium zetium_rate zetium_storage
        last_resources_update energy_diminish_registered}
      it_should_behave_like "to json"
    end
  end
end