require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

class Building::HealingTest < Building
  include Parts::Healing
end
Factory.define(:b_healing_test, :class => Building::HealingTest,
               :parent => :building) do |m|
  m.level 1
end

describe Building::HealingTest do
  let(:building) { Factory.build(:b_healing_test) }
  before(:all) do
    CONFIG['buildings.healing_test.healing.cost.mod'] = '10 - 2 * level'
    CONFIG['buildings.healing_test.healing.time.mod'] =
      '(0.35 - 0.1 * level) / speed'
  end

  describe "#resources_for_healing" do
    [:unit_built, :building_built].each do |kind|
      it "should return resources for level 1 for #{kind}" do
        healable = Factory.build!(kind, :level => 3, :hp_percentage => 0.35)
        percentage = (1 - healable.hp.to_f / healable.hit_points)
        mod = building.cost_modifier
        building.resources_for_healing(healable).should == [
          (healable.metal_cost(1) * percentage * mod).round,
          (healable.energy_cost(1) * percentage * mod).round,
          (healable.zetium_cost(1) * percentage * mod).round
        ]
      end
    end
  end

  describe "#cost_modifier" do
    it "should return value" do
      building.level = 2
      building.cost_modifier.should == 6
    end
  end

  describe "#healing_time" do
    it "should return ceiled values" do
      building.level = 2
      building.healing_time(10).should == 2
    end
  end
end