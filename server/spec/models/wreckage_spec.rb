require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Wreckage do
  describe "#as_json" do
    before(:each) do
      @model = Factory.create(:wreckage)
    end

    @required_fields = %w{location metal energy zetium}
    @ommited_fields = %w{id galaxy_id}
    it_should_behave_like "to json"
  end

  describe ".add" do
    it "should raise error if metal is negative" do
      lambda do
        Wreckage.add(GalaxyPoint.new(1, 0, 0), -1, 0, 0)
      end.should raise_error(ArgumentError)
    end

    it "should raise error if energy is negative" do
      lambda do
        Wreckage.add(GalaxyPoint.new(1, 0, 0), 0, -1, 0)
      end.should raise_error(ArgumentError)
    end

    it "should raise error if zetium is negative" do
      lambda do
        Wreckage.add(GalaxyPoint.new(1, 0, 0), 0, 0, -1)
      end.should raise_error(ArgumentError)
    end

    it "should create new Wreckage if one does not exist in galaxy" do
      galaxy = Factory.create(:galaxy)
      location = GalaxyPoint.new(galaxy.id, 0, 0)
      wreckage = Wreckage.add(location, 10, 10, 10)
      Wreckage.in_location(location).first.should == wreckage
    end

    it "should create new Wreckage if one does not exist in solar system" do
      ss = Factory.create(:solar_system)
      location = SolarSystemPoint.new(ss.id, 0, 0)
      wreckage = Wreckage.add(location, 10, 10, 10)
      Wreckage.in_location(location).first.should == wreckage
    end

    it "should add to planets resources if location is planet" do
      planet = Factory.create(:planet, :metal => 0, :energy => 0,
        :zetium => 0)
      Wreckage.add(planet, 10, 11, 12)
      planet.reload
      planet.metal.should == 10
      planet.energy.should == 11
      planet.zetium.should == 12
    end

    it "should fire changed with planet" do
      planet = Factory.create(:planet, :metal => 0, :energy => 0,
        :zetium => 0)
      should_fire_event(planet, EventBroker::CHANGED) do
        Wreckage.add(planet, 10, 11, 12)
      end
    end

    it "should update existing wreckages" do
      wreckage = Factory.create(:wreckage)
      old_metal, old_energy, old_zetium = wreckage.metal, wreckage.energy,
        wreckage.zetium
      Wreckage.add(wreckage.location, 11, 12, 13)
      wreckage.reload
      wreckage.metal.should == old_metal + 11
      wreckage.energy.should == old_energy + 12
      wreckage.zetium.should == old_zetium + 13
    end
  end

  describe ".subtract" do
    it "should raise error if metal is negative" do
      lambda do
        Wreckage.subtract(GalaxyPoint.new(1, 0, 0), -1, 0, 0)
      end.should raise_error(ArgumentError)
    end

    it "should raise error if energy is negative" do
      lambda do
        Wreckage.subtract(GalaxyPoint.new(1, 0, 0), 0, -1, 0)
      end.should raise_error(ArgumentError)
    end

    it "should raise error if zetium is negative" do
      lambda do
        Wreckage.subtract(GalaxyPoint.new(1, 0, 0), 0, 0, -1)
      end.should raise_error(ArgumentError)
    end

    it "should raise error if record is not found by location" do
      lambda do
        Wreckage.subtract(GalaxyPoint.new(0, 0, 0), 1, 1, 1)
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should update existing wreckages" do
      wreckage = Factory.create(:wreckage)
      old_metal, old_energy, old_zetium = wreckage.metal, wreckage.energy,
        wreckage.zetium
      Wreckage.subtract(wreckage.location, 1, 2, 3)
      wreckage.reload
      wreckage.metal.should == old_metal - 1
      wreckage.energy.should == old_energy - 2
      wreckage.zetium.should == old_zetium - 3
    end

    it "should not remove wreckage if only one resource is depleted" do
      wreckage = Factory.create(:wreckage)
      Wreckage.subtract(wreckage.location, 0, 0, wreckage.zetium)
      lambda do
        wreckage.reload
      end.should_not raise_error(ActiveRecord::RecordNotFound)
    end

    it "should remove wreckage if it is depleted" do
      wreckage = Factory.create(:wreckage)
      Wreckage.subtract(wreckage.location, wreckage.metal, wreckage.energy,
        wreckage.zetium)
      lambda do
        wreckage.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should remove wreckage if it is depleted (with tolerance)" do
      wreckage = Factory.create(:wreckage)
      Wreckage.subtract(wreckage.location,
        wreckage.metal - Wreckage::REMOVAL_TOLERANCE + 0.1,
        wreckage.energy - Wreckage::REMOVAL_TOLERANCE + 0.1,
        wreckage.zetium - Wreckage::REMOVAL_TOLERANCE + 0.1)
      lambda do
        wreckage.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe ".calculate" do
    it "should calculate resources for units" do
      CONFIG.stub!(:hashrand).and_return do |key|
        case key
        when "combat.wreckage.metal"
          10
        when "combat.wreckage.energy"
          21
        when "combat.wreckage.zetium"
          32
        end
      end
      unit = Factory.create(:u_crow)
      metal = unit.metal_cost * 0.1
      energy = unit.energy_cost * 0.21
      zetium = unit.zetium_cost * 0.32
      w_metal, w_energy, w_zetium = Wreckage.calculate([unit])
      w_metal.should be_close(metal, 0.1)
      w_energy.should be_close(energy, 0.1)
      w_zetium.should be_close(zetium, 0.1)
    end

    it "should add transported resources" do
      CONFIG.stub!(:hashrand).and_return(0)
      unit = Factory.create(:u_mule, :metal => 1000, :energy => 1200,
        :zetium => 1400, :stored => 10)
      Wreckage.calculate([unit]).should == [unit.metal, unit.energy,
        unit.zetium]
    end

    it "should add transported units" do
      CONFIG.stub!(:hashrand).and_return do |key|
        case key
        when "combat.wreckage.metal"
          10
        when "combat.wreckage.energy"
          21
        when "combat.wreckage.zetium"
          32
        end
      end
      unit = Factory.create(:u_mule, :stored => 40)
      loaded = Factory.create(:u_scorpion, :location => unit)
      metal = (unit.metal_cost + loaded.metal_cost) * 0.1
      energy = (unit.energy_cost + loaded.energy_cost) * 0.21
      zetium = (unit.zetium_cost + loaded.zetium_cost) * 0.32
      w_metal, w_energy, w_zetium = Wreckage.calculate([unit])
      w_metal.should be_close(metal, 0.1)
      w_energy.should be_close(energy, 0.1)
      w_zetium.should be_close(zetium, 0.1)
    end
  end
end