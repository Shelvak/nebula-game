require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

class Building::GeothermalPlantTraitMock < Building
  include Trait::GeothermalPlant
end

Factory.define :b_geothermal_plant_trait, :parent => :b_trait_mock,
:class => Building::GeothermalPlantTraitMock do |m|; end

describe Building::GeothermalPlantTraitMock do
  it "should be able to build on geothermal tiles" do
    tile = Factory.create :t_geothermal
    building = Factory.build :b_geothermal_plant_trait,
      :planet => tile.planet,
      :x => tile.x, :y => tile.y
    building.should be_valid
  end

  it "should only allow to be built on geothermal tiles" do
    building = Factory.build(:b_geothermal_plant_trait)
    building.should_not be_valid
  end
end