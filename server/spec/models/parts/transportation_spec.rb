require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Parts::Transportation do
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
      @loadable = Factory.create(:u_loadable_test)
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

    it "should fire changed on transporter" do
      should_fire_event([@transporter], EventBroker::CHANGED) do
        @transporter.load([@loadable])
      end
    end

    it "should fire changed on loaded units" do
      should_fire_event([@loadable], EventBroker::DESTROYED,
          EventBroker::REASON_LOADED) do
        @transporter.load([@loadable])
      end
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

    it "should fire changed on transporter" do
      should_fire_event([@transporter], EventBroker::CHANGED) do
        @transporter.unload([@loadable], @planet)
      end
    end

    it "should fire changed on unloaded units" do
      should_fire_event([@loadable], EventBroker::CHANGED,
          EventBroker::REASON_UNLOADED) do
        @transporter.unload([@loadable], @planet)
      end
    end
  end
end

