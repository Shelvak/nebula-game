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
    it "should return resources" do
      unit = Factory.build(:u_crow, :level => 1, :hp_percentage => 0.35)
      percentage = (1 - unit.hp.to_f / unit.hit_points)
      mod = building.cost_modifier
      building.resources_for_healing(unit).should == [
        (unit.metal_cost * percentage * mod).round,
        (unit.energy_cost * percentage * mod).round,
        (unit.zetium_cost * percentage * mod).round
      ]
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