require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Parts::Transportation do
  describe "after destroy" do
    it "should reduce parent unit storage" do
      transporter = Factory.create(:u_with_storage,
        :stored => CONFIG['units.loadable_test.volume'])
      unit = Factory.create(:u_loadable_test, :location => transporter)
      lambda do
        unit.destroy
        transporter.reload
      end.should change(transporter, :stored).by(- unit.volume)
    end

    it "should dispatch changed with parent unit" do
      transporter = Factory.create(:u_with_storage,
        :stored => CONFIG['units.loadable_test.volume'])
      unit = Factory.create(:u_loadable_test, :location => transporter)
      should_fire_event(transporter, EventBroker::CHANGED) do
        unit.destroy
      end
    end

    it "should remove all loaded units" do
      mule = Factory.create(:u_mule)
      loaded = Factory.create(:u_trooper, :location => mule)
      mule.destroy
      lambda do
        loaded.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#storage" do
    before(:all) do
      @unit = Factory.create(:u_with_storage)
    end

    it "should return storage if specified" do
      @unit.storage.should == CONFIG['units.with_storage.storage']
    end

    it "should return 0 if not specified" do
      with_config_values 'units.with_storage.storage' => nil do
        @unit.storage.should == 0
      end
    end
  end

  describe "#unload_per_tick" do
    before(:all) do
      @unit = Factory.create(:u_with_storage)
    end

    it "should return storage if specified" do
      @unit.unload_per_tick(2).should == CONFIG.evalproperty(
        'units.with_storage.unload_per_tick', 'level' => 2)
    end

    it "should return nil if not specified" do
      with_config_values 'units.with_storage.unload_per_tick' => nil do
        lambda do
          @unit.unload_per_tick
        end.should raise_error(ArgumentError)
      end
    end
  end

  describe "#volume" do
    before(:all) do
      @unit = Factory.create(:u_loadable_test)
    end

    it "should return volume if specified" do
      @unit.volume.should == CONFIG['units.loadable_test.volume']
    end

    it "should return nil if not specified" do
      with_config_values 'units.loadable_test.volume' => nil do
        @unit.volume.should be_nil
      end
    end
  end

  describe "#load" do
    before(:each) do
      @transporter = Factory.create(:u_with_storage)
      @loadable = Factory.create(:u_loadable_test,
        :location => @transporter.location)
    end

    it "should raise error if given blank array" do
      lambda do
        @transporter.load([])
      end.should raise_error(GameLogicError)
    end

    it "should raise error if trying to load untransportable unit" do
      with_config_values 'units.loadable_test.volume' => nil do
        lambda do
          @transporter.load([@loadable])
        end.should raise_error(GameLogicError)
      end
    end

    it "should raise error if units are not in same location" do
      @loadable.location = Factory.create(:planet)
      @loadable.save!

      lambda do
        @transporter.load([@loadable])
      end.should raise_error(GameLogicError)
    end

    it "should raise error if there is not enough space" do
      with_config_values(
        'units.loadable_test.volume' => @transporter.storage + 1
      ) do
        lambda do
          @transporter.load([@loadable])
        end.should raise_error(GameLogicError)
      end
    end

    it "should increase used storage counter" do
      lambda do
        @transporter.load([@loadable])
      end.should change(@transporter, :stored).by(@loadable.volume)
    end

    it "should save unit" do
      @transporter.load([@loadable])
      @transporter.should_not be_changed
    end

    it "should update loaded units location" do
      @transporter.load([@loadable])
      @loadable.reload
      @loadable.location.object.should == @transporter
    end

    it "should fire changed on transporter & loaded units" do
      should_fire_event([@transporter, @loadable], EventBroker::CHANGED) do
        @transporter.load([@loadable])
      end
    end

    it "should change loaded units location" do
      lambda do
        @transporter.load([@loadable])
      end.should change(@loadable, :location).to(
        @transporter.location_point)
    end
  end

  describe "#load_resources!" do
    before(:each) do
      @planet = Factory.create(:planet)
      set_resources(@planet, 1000, 1000, 1000)
      @transporter = Factory.create(:u_with_storage, :location => @planet)
    end

    it "should raise error if transporter is not in planet" do
      @transporter.location = Factory.create(:planet)
      lambda do
        @transporter.load_resources!(@planet, 1, 1, 1)
      end.should raise_error(GameLogicError)
    end

    it "should raise error if transporter is not on wreckage" do
      wreckage = Factory.create(:wreckage, :location =>
          @planet.solar_system_point)
      lambda do
        @transporter.load_resources!(wreckage, 1, 1, 1)
      end.should raise_error(GameLogicError)
    end

    %w{metal energy zetium}.each_with_index do |resource, index|
      resources = Array.new(3, 0)
      resources[index] = 10

      it "should fail if trying to load negative #{resource}" do
        res = resources.dup
        res[index] *= -1
        lambda do
          @transporter.load_resources!(@planet, *res)
        end.should raise_error(GameLogicError)
      end

      it "should reduce #{resource} from planet" do
        lambda do
          @transporter.load_resources!(@planet, *resources)
        end.should change(@planet, resource).by(-10)
      end

      it "should increase #{resource} on transporter" do
        lambda do
          @transporter.load_resources!(@planet, *resources)
        end.should change(@transporter, resource).by(10)
      end
      
      it "should raise error if not enough #{resource} on planet" do
        set_resources(@planet, *resources)
        res = resources.dup
        res[index] += 1
        lambda do
          @transporter.load_resources!(@planet, *res)
        end.should raise_error(GameLogicError)
      end
      
      it "should raise error if not enough space for #{resource
      } on transporter" do
        @transporter.stored = @transporter.storage
        lambda do
          @transporter.load_resources!(@planet, *resources)
        end.should raise_error(GameLogicError)
      end

      it "should load resources if storage is full but loaded resources " +
      "do not take additional storage" do
        @transporter.stored = @transporter.storage
        @transporter[resource] =
          CONFIG["units.transportation.volume.#{resource}"] - 1
        res = Array.new(3, 0)
        res[index] = 1
        lambda do
          @transporter.load_resources!(@planet, *res)
        end.should_not raise_error
      end
    end

    it "should increase stored on transporter" do
      lambda do
        @transporter.load_resources!(@planet, 1, 1, 1)
      end.should change(@transporter, :stored).by(3)
    end

    it "should fire changed with self" do
      should_fire_event([@transporter, @planet], EventBroker::CHANGED) do
        @transporter.load_resources!(@planet, 1, 1, 1)
      end
    end

    it "should save planet" do
      @transporter.load_resources!(@planet, 1, 1, 1)
      @planet.should be_saved
    end

    it "should save transporter" do
      @transporter.load_resources!(@planet, 1, 1, 1)
      @transporter.should be_saved
    end

    it "should support wreckages" do
      @transporter.location = @planet.solar_system_point
      wreckage = Factory.create(:wreckage, :location =>
          @planet.solar_system_point)
      @transporter.load_resources!(wreckage, 1, 1, 1)
    end

    it "should raise error if no wreckage is there" do
      @transporter.location = @planet.solar_system_point
      wreckage = Factory.create(:wreckage)
      lambda do
        @transporter.load_resources!(wreckage, 1, 1, 1)
      end.should raise_error(GameLogicError)
    end
  end
  
  describe "#unload" do
    before(:each) do
      @transporter = Factory.create(:u_with_storage,
        :stored => CONFIG['units.loadable_test.volume'])
      @loadable = Factory.create(:u_loadable_test,
        :location => @transporter)
      @planet = Factory.create(:planet)
    end

    it "should raise error if given blank array" do
      lambda do
        @transporter.unload([], @planet)
      end.should raise_error(GameLogicError)
    end

    it "should decrease used storage counter" do
      lambda do
        @transporter.unload([@loadable], @planet)
      end.should change(@transporter, :stored).by(- @loadable.volume)
    end

    it "should save unit" do
      @transporter.unload([@loadable], @planet)
      @transporter.should_not be_changed
    end

    it "should update unloaded units location" do
      @transporter.unload([@loadable], @planet)
      @loadable.reload
      @loadable.location.should == @planet.location_point
    end

    it "should fire changed on unloaded units" do
      should_fire_event([@transporter, @loadable], EventBroker::CHANGED) do
        @transporter.unload([@loadable], @planet)
      end
    end

    it "should change unloaded units location" do
      lambda do
        @transporter.unload([@loadable], @planet)
      end.should change(@loadable, :location).to(@planet.location_point)
    end
  end

  describe "#unload_resources!" do
    before(:each) do
      @planet = Factory.create(:planet)
      @planet.metal = @planet.energy = @planet.zetium =
        @planet.metal_rate = @planet.energy_rate = @planet.zetium_rate = 0
      @planet.metal_storage = @planet.energy_storage =
        @planet.zetium_storage = 1000

      @transporter = Factory.create(:u_with_storage, :location => @planet)
      @transporter.metal = @transporter.energy = @transporter.zetium = 10
      @transporter.stored = @transporter.class.calculate_resources_volume(
        @transporter.metal, @transporter.energy, @transporter.zetium)
    end

    it "should raise error if transporter is not in planet" do
      @transporter.location = Factory.create(:planet)
      lambda do
        @transporter.unload_resources!(@planet, 1, 1, 1)
      end.should raise_error(GameLogicError)
    end

    %w{metal energy zetium}.each_with_index do |resource, index|
      resources = Array.new(3, 0)
      resources[index] = 10

      it "should fail if trying to load negative #{resource}" do
        res = resources.dup
        res[index] *= -1
        lambda do
          @transporter.unload_resources!(@planet, *res)
        end.should raise_error(GameLogicError)
      end

      it "should raise error if trying to unload more #{resource} than " +
      "we have" do
        lambda do
          res = resources.dup
          res[index] += 1
          @transporter.unload_resources!(@planet, *res)
        end.should raise_error(GameLogicError)
      end

      it "should increase #{resource} on planet" do
        lambda do
          @transporter.unload_resources!(@planet, *resources)
        end.should change(@planet, resource).by(10)
      end

      it "should decrease #{resource} on transporter" do
        lambda do
          @transporter.unload_resources!(@planet, *resources)
        end.should change(@transporter, resource).by(-10)
      end

      it "should not overfill #{resource} on planet" do
        @planet.send("#{resource}_storage=", 8)
        lambda do
          @transporter.unload_resources!(@planet, *resources)
        end.should change(@planet, resource).by(8)
      end
    end

    it "should calculate stored volume correctly" do
      lambda do
        @transporter.unload_resources!(@planet, 1, 1, 1)
      end.should_not change(@transporter, :stored)
    end

    it "should decrease stored on transporter" do
      lambda do
        @transporter.unload_resources!(@planet, @transporter.metal,
          @transporter.energy, @transporter.zetium)
      end.should change(@transporter, :stored).to(0)
    end

    it "should fire changed with self" do
      should_fire_event([@transporter, @planet], EventBroker::CHANGED) do
        @transporter.unload_resources!(@planet, 1, 1, 1)
      end
    end

    it "should save planet" do
      @transporter.unload_resources!(@planet, 1, 1, 1)
      @planet.should be_saved
    end

    it "should save transporter" do
      @transporter.unload_resources!(@planet, 1, 1, 1)
      @transporter.should be_saved
    end

    it "should support wreckages" do
      @transporter.location = @planet.solar_system_point
      wreckage = Factory.create(:wreckage, :location =>
          @planet.solar_system_point)
      @transporter.unload_resources!(wreckage, 1, 1, 1)
    end

    it "should create wreckage if none is there" do
      @transporter.location = @planet.solar_system_point
      @transporter.unload_resources!(@planet.solar_system_point, 1, 1, 1)
      Wreckage.in_location(@planet.solar_system_point).first.should_not \
        be_nil
    end
  end

  describe ".calculate_resources_volume" do
    before(:all) do
      @transporter = Factory.create(:u_with_storage)
    end

    it "should calculate metal ceiled" do
      with_config_values(
        'units.transportation.volume.metal' => 0.32
      ) do
        @transporter.class.calculate_resources_volume(3, 0, 0).should == 10
      end
    end

    it "should calculate energy ceiled" do
      with_config_values(
        'units.transportation.volume.energy' => 0.32
      ) do
        @transporter.class.calculate_resources_volume(0, 3, 0).should == 10
      end
    end

    it "should calculate zetium ceiled" do
      with_config_values(
        'units.transportation.volume.zetium' => 0.32
      ) do
        @transporter.class.calculate_resources_volume(0, 0, 3).should == 10
      end
    end

    it "should return total sum" do
      with_config_values(
        'units.transportation.volume.metal' => 0.32,
        'units.transportation.volume.energy' => 0.32,
        'units.transportation.volume.zetium' => 0.32
      ) do
        @transporter.class.calculate_resources_volume(1, 2, 3).should ==
          4 + 7 + 10
      end
    end
  end
end

