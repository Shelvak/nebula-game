require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Unit::DeployableTest do
  describe "#deploy" do
    before(:each) do
      @unit = Factory.create(:u_deployable_test)
      @planet = Factory.create(:planet)
    end

    it "should check if it's deployable" do
      with_config_values "units.deployable_test.deploys_to" => nil do
        lambda do
          @unit.deploy(@planet, 0, 0)
        end.should raise_error(GameLogicError)
      end
    end

    it "should create new building" do
      @unit.deploy(@planet, 0, 0)
      Building::Vulcan.where(
        :planet_id => @planet.id, :x => 0, :y => 0
      ).first.should_not be_nil
    end

    it "should set level to 0" do
      @unit.deploy(@planet, 0, 0)
      Building::Vulcan.where(
        :planet_id => @planet.id, :x => 0, :y => 0
      ).first.level.should == 0
    end

    it "should start building upgrade" do
      @unit.deploy(@planet, 0, 0)
      Building::Vulcan.where(
        :planet_id => @planet.id, :x => 0, :y => 0
      ).first.should be_upgrading
    end

    it "should not check technologies" do
      Building::Vulcan.needs_technology(Technology::Vulcan, 'level' => 1)
      lambda do
        @unit.deploy(@planet, 0, 0)
      end.should_not raise_error(ActiveRecord::RecordInvalid)
    end

    it "should not check planet resources" do
      re = @planet.resources_entry
      set_resources(re, 100, 100, 100)
      lambda do
        @unit.deploy(@planet, 0, 0)
      end.should_not raise_error(ActiveRecord::RecordInvalid)
    end

    %w{metal energy zetium}.each do |resource|
      it "should not reduce planet #{resource}" do
        re = @planet.resources_entry
        set_resources(re, 100, 100, 100)
        @unit.deploy(@planet, 0, 0)
        lambda do
          re.reload
        end.should_not change(re, resource)
      end
    end

    it "should destroy unit" do
      @unit.deploy(@planet, 0, 0)
      lambda do
        @unit.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should dispatch destroyed event" do
      should_fire_event(@unit, EventBroker::DESTROYED) do
        @unit.deploy(@planet, 0, 0)
      end
    end
  end
end