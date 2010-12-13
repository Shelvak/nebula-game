require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::SolarPlant do
  it "should manage resources" do
    Building::SolarPlant.should manage_resources
  end

  it "should generate energy" do
    Factory.create(:b_solar_plant).energy_generation_rate.should > 0
  end
end