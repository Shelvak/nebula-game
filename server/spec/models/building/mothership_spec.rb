require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::Mothership do
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
end