require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe SsObject::Asteroid do
  describe "#as_json" do
    before(:all) do
      @model = Factory.create(:sso_asteroid)
    end

    describe "without options" do
      @ommited_fields = %w{width height metal energy zetium
        last_resources_update metal_rate metal_storage
        energy_rate energy_storage zetium_rate zetium_storage}
      it_should_behave_like "to json"
    end

    describe "with resources" do
      before(:each) do
        @options = {:resources => true}
      end

      @required_fields = %w{metal_rate metal_storage
      energy_rate energy_storage zetium_rate zetium_storage}
      @ommited_fields = %w{width height metal energy zetium
        last_resources_update}
      it_should_behave_like "to json"
    end
  end

  describe "#spawn_resources!" do
    before(:each) do
      @model = Factory.create(:sso_asteroid)
    end

    it "should spawn a wreckage" do
      @model.spawn_resources!
      Wreckage.in_location(@model.solar_system_point).first.should_not be_nil
    end

    %w{metal energy zetium}.each do |resource|
      it "should multiply coef with config value for #{resource}" do
        with_config_values(
          'ss_object.asteroid.wreckage.metal.spawn' => [100, 100],
          'ss_object.asteroid.wreckage.energy.spawn' => [300, 300],
          'ss_object.asteroid.wreckage.zetium.spawn' => [50, 50]
        ) do
          @model.spawn_resources!
          wreckage = Wreckage.in_location(@model.solar_system_point).first
          wreckage.send(resource).should == @model.send(
            "#{resource}_rate") * CONFIG[
            "ss_object.asteroid.wreckage.#{resource}.spawn"][0]
        end
      end

      it "should take a value from config range for #{resource}" do
        @model.spawn_resources!
        wreckage = Wreckage.in_location(@model.solar_system_point).first
        (@model.send(
          "#{resource}_rate") * CONFIG[
          "ss_object.asteroid.wreckage.#{resource}.spawn"
        ][0]..@model.send(
          "#{resource}_rate") * CONFIG[
          "ss_object.asteroid.wreckage.#{resource}.spawn"
        ][1]).should include(wreckage.send(resource))
      end

      it "should add #{resource} if wreckage already exists" do
        wreckage = Wreckage.add(@model.solar_system_point, 100, 100, 100)
        @model.spawn_resources!
        wreckage.reload
        wreckage.send(resource).should be > 100
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

  describe ".on_callback" do
    it "should spawn resources" do
      mock = mock(SsObject::Asteroid)
      SsObject::Asteroid.should_receive(:find).with(1).and_return(mock)
      mock.should_receive(:spawn_resources!)

      SsObject::Asteroid.on_callback(1, CallbackManager::EVENT_SPAWN)
    end
  end
end