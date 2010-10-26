require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::MetalStorage do
  it "should manage resources" do
    Building::MetalStorage.should manage_resources
  end

  it "should store metal" do
    Factory.create(:b_metal_storage).metal_storage.should be_greater_than(0)
  end
end