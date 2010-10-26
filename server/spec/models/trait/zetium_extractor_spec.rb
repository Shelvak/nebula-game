require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

class Building::ZetiumExtractorTraitMock < Building
  include Trait::ZetiumExtractor
end

Factory.define :b_zetium_extractor_trait, :parent => :b_trait_mock,
:class => Building::ZetiumExtractorTraitMock do |m|; end

describe Building::ZetiumExtractorTraitMock do
  it "should be able to build on zetium tiles" do
    tile = Factory.create :t_zetium
    building = Factory.build :b_zetium_extractor_trait,
      :planet => tile.planet,
      :x => tile.x, :y => tile.y
    lambda { building.save! }.should_not raise_error(
      ActiveRecord::RecordInvalid)
  end

  it "should only allow to be built on zetium tiles" do
    building = Factory.build(:b_zetium_extractor_trait)
    building.should_not be_valid
  end
end