require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Building::Mothership do
  it "should be a constructor" do
    Building::Mothership.should be_constructor
  end

  it "should manage resources" do
    Building::Mothership.should manage_resources
  end

  it "should generate energy" do
    Building::Mothership.energy_generation_rate(1).should > 0
  end

  it "should generate metal" do
    Building::Mothership.metal_generation_rate(1).should > 0
  end
  
  it "should store energy" do
    Building::Mothership.energy_storage(1).should > 0
  end

  it "should store metal" do
    Building::Mothership.metal_storage(1).should > 0
  end
end