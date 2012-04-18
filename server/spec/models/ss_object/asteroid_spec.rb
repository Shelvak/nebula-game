require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe SsObject::Asteroid do
  describe "#current_resources" do
    it "should return [0, 0, 0] if no wreckage exists" do
      Factory.create(:sso_asteroid).current_resources.should == [0, 0, 0]
    end
    
    it "should return [metal, energy, zetium] if wreckage exists" do
      asteroid = Factory.create(:sso_asteroid)
      wreckage = Factory.create(:wreckage, 
        :location => asteroid.solar_system_point)
      asteroid.current_resources.should == [wreckage.metal, wreckage.energy,
        wreckage.zetium]
    end
  end
  
  describe "#spawn_modifiers" do
    it "should return modifiers by how much of the quota is filled" do
      metal = 1500.0
      energy = 5000.0
      zetium = 100.0
      
      asteroid = Factory.create(:sso_asteroid)
      asteroid.stub!(:current_resources).and_return([metal, energy, zetium])
      asteroid.spawn_modifiers.should == [
        1 - metal / CONFIG['ss_object.asteroid.wreckage.metal.spawn.max'],
        1 - energy / CONFIG['ss_object.asteroid.wreckage.energy.spawn.max'],
        1 - zetium / CONFIG['ss_object.asteroid.wreckage.zetium.spawn.max'],
      ]
    end
    
    it "should not return values below 0" do
      metal = CONFIG['ss_object.asteroid.wreckage.metal.spawn.max'] + 1000
      energy = CONFIG['ss_object.asteroid.wreckage.energy.spawn.max'] + 1000
      zetium = CONFIG['ss_object.asteroid.wreckage.zetium.spawn.max'] + 1000
      
      asteroid = Factory.create(:sso_asteroid)
      asteroid.stub!(:current_resources).and_return([metal, energy, zetium])
      asteroid.spawn_modifiers.should == [0, 0, 0]
    end
  end

  describe "#spawn_resources!" do
    before(:each) do
      @model = Factory.create(:sso_asteroid)
    end

    it "should add to wreckage @ its solar system point" do
      metal_range = 100..200
      energy_range = 300..500
      zetium_range = 50..90
      
      metal_spawn_mod = 0.3
      energy_spawn_mod = 0.56
      zetium_spawn_mod = 0.98
      
      with_config_values(
        'ss_object.asteroid.wreckage.metal.spawn' => 
          [metal_range.first, metal_range.last],
        'ss_object.asteroid.wreckage.energy.spawn' => 
          [energy_range.first, energy_range.last],
        'ss_object.asteroid.wreckage.zetium.spawn' => 
          [zetium_range.first, zetium_range.last]
      ) do
        @model.stub!(:spawn_modifiers).
          and_return([metal_spawn_mod, energy_spawn_mod, zetium_spawn_mod])
        
        Wreckage.should_receive(:add).and_return do 
          |location, metal, energy, zetium|
          
          location.should == @model.solar_system_point
          (metal_range * @model.metal_generation_rate * metal_spawn_mod).
            should cover(metal)
          (energy_range * @model.energy_generation_rate * energy_spawn_mod).
            should cover(energy)
          (zetium_range * @model.zetium_generation_rate * zetium_spawn_mod).
            should cover(zetium)
        end
        
        @model.spawn_resources!
      end
    end

    it "should register a new callback" do
      with_config_values(
        'ss_object.asteroid.wreckage.time.spawn' => [10.minutes, 10.minutes]
      ) do
        @model.spawn_resources!
        @model.should have_callback(CallbackManager::EVENT_SPAWN,
          10.minutes.from_now)
      end
    end
  end

  describe "callbacks" do
    describe ".spawn_callback" do
      it "should have scope" do
        SsObject::SPAWN_SCOPE
      end

      it "should spawn resources" do
        mock = mock(SsObject::Asteroid)
        mock.should_receive(:spawn_resources!)

        SsObject.spawn_callback(mock)
      end
    end
  end
end