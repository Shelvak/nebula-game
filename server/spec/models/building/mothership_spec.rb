require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::Mothership do
  it "should have radar" do
    Building::Mothership.should include(Trait::Radar)
  end

  it "should be a constructor" do
    Building::Mothership.should be_constructor
  end

  it "should manage resources" do
    Building::Mothership.should manage_resources
  end

  it "should generate energy" do
    Factory.create(:b_mothership).energy_generation_rate.should be_greater_than(0)
  end

  it "should generate metal" do
    Factory.create(:b_mothership).metal_generation_rate.should be_greater_than(0)
  end
  
  it "should store energy" do
    Factory.create(:b_mothership).energy_storage.should be_greater_than(0)
  end

  it "should store metal" do
    Factory.create(:b_mothership).metal_storage.should be_greater_than(0)
  end

  describe "upgrade finished" do
    before(:each) do
      @building = Factory.create(:b_mothership, 
        opts_inactive + {:level => 0})
    end

    %w{metal energy zetium}.each do |resource|
      it "should set #{resource} to a starting amount" do
        @building.send(:on_upgrade_finished)
        @building.save!

        @building.planet.resources_entry.send(resource).should == (
          CONFIG[
            "buildings.mothership.#{resource}.starting"
          ] || 0
        )
      end

      it "should add #{resource} storage" do
        re = @building.planet.resources_entry
        storage = "#{resource}_storage"

        lambda do
          @building.send(:on_upgrade_finished)
          @building.save!
          re.reload
        end.should change(re, storage).by(@building.send(storage, 1))
      end
    end
  end
end