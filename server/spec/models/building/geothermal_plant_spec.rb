require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::GeothermalPlant do
  it "should manage_resources" do
    Building::GeothermalPlant.should manage_resources
  end

  it "should include GeothermalPlant" do
    Building::GeothermalPlant.should include(Trait::GeothermalPlant)
  end
end