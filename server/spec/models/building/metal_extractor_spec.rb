require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::MetalExtractor do
  before(:each) do
    @planet = Factory.create :planet
    @tile = Factory.create :t_ore, :planet => @planet, :x => 20, :y => 20
    @args = {:planet => @planet, :x => 20, :y => 20}
  end

  it "should manage resources" do
    Building::MetalExtractor.should manage_resources
  end

  it "should include MetalExtractor" do
    Building::MetalExtractor.should include(Trait::MetalExtractor)
  end

  it "should use energy" do
    Factory.create(:b_metal_extractor, @args).energy_usage_rate.should > 0
  end

  it "should generate metal" do
    Factory.create(:b_metal_extractor, @args).metal_generation_rate.should > 0
  end
end