require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

class Building::RepairableTest < Building
  include Parts::Repairable
end
Factory.define(:b_repairable_test, :class => Building::RepairableTest,
               :parent => :building_built) {}

describe Building::RepairableTest do
  let(:building) { Factory.create!(:b_repairable_test) }

  describe "#repair!" do
    it "should fail if planet has no owner" do
      
    end
    
    it "should fail if player does not have building repair technology" do
      
    end

    it "should fail if player has level 0 technology" do
      
    end

    it "should fail if planet does not have enough resources" do

    end

    it "should reduce resources from planet" do

    end

    it "should set cooldown on building" do

    end

    it "should change state to repairing" do

    end

    it "should fire updated on building" do

    end

    it "should fire updated on planet" do

    end

    it "should progress RepairHp objective" do
      
    end
  end

  describe "#on_repairs_finished!" do
    before(:each) do
      building.hp_percentage = 0.34
      building.state = Building::STATE_REPAIRING
      building.cooldown_ends_at = 87.minutes.from_now
    end

    it "should restore hp" do
      lambda do
        building.on_repairs_finished!
        building.reload
      end.should change(building, :hp_percentage).to(1)
    end

    it "should activate building" do
      lambda do
        building.on_repairs_finished!
        building.reload
      end.should change(building, :state).to(Building::STATE_ACTIVE)
    end

    it "should nullify #cooldown_ends_at" do
      lambda do
        building.on_repairs_finished!
        building.reload
      end.should change(building, :cooldown_ends_at).to(nil)
    end

    it "should dispatch changed" do
      should_fire_event(building, EventBroker::CHANGED) do
        building.on_repairs_finished!
      end
    end
  end

  describe ".on_callback" do
    it "should find model and call #on_repairs_finished! on it" do

    end
  end
end