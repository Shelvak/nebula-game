require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Resources do
  describe ".total_volume" do
    it "should calculate metal ceiled" do
      with_config_values(
        'units.transportation.volume.metal' => 0.32
      ) do
        Resources.total_volume(3, 0, 0).should == 10
      end
    end

    it "should calculate energy ceiled" do
      with_config_values(
        'units.transportation.volume.energy' => 0.32
      ) do
        Resources.total_volume(0, 3, 0).should == 10
      end
    end

    it "should calculate zetium ceiled" do
      with_config_values(
        'units.transportation.volume.zetium' => 0.32
      ) do
        Resources.total_volume(0, 0, 3).should == 10
      end
    end

    it "should return total sum" do
      with_config_values(
        'units.transportation.volume.metal' => 0.32,
        'units.transportation.volume.energy' => 0.32,
        'units.transportation.volume.zetium' => 0.32
      ) do
        Resources.total_volume(1, 2, 3).should ==
          4 + 7 + 10
      end
    end
  end

  describe ".resource_volume" do
    it "should log error if exception is raised" do
      LOGGER.should_receive(:error)
      begin
        Resources.resource_volume(1.0/0, "metal")
      rescue Exception
      end
    end

    it "should reraise the error" do
      lambda do
        Resources.resource_volume(1.0/0, "metal")
      end.should raise_error
    end
  end
end