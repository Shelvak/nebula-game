require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::EnergyStorage do
  it "should manage resources" do
    Building::EnergyStorage.should manage_resources
  end

  it "should store energy" do
    Factory.create(:b_energy_storage).energy_storage.should > 0
  end
end