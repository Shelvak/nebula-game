require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

class Building::MetalExtractorTraitMock < Building
  include Trait::MetalExtractor
end

Factory.define :b_metal_extractor_trait, :parent => :b_trait_mock,
:class => Building::MetalExtractorTraitMock do |m|; end

describe Building::MetalExtractorTraitMock do
  it "should be able to build on ore tiles" do
    tile = Factory.create :t_ore
    building = Factory.build :b_metal_extractor_trait,
      :planet => tile.planet,
      :x => tile.x, :y => tile.y
    building.should be_valid
  end

  it "should only allow to be built on ore tiles" do
    building = Factory.build(:b_metal_extractor_trait)
    building.should_not be_valid
  end
end