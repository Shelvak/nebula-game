require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

class Building::RepairableTest < Building
  include Parts::Repairable
end
Factory.define(:b_repairable_test, :class => Building::RepairableTest,
               :parent => :building_built) {}

describe Building::RepairableTest do
  describe "#check_upgrade!" do
    it "should fail if repairing" do
      b = Factory.build(:b_repairable_test, :state => Building::STATE_REPAIRING)
      lambda do
        b.check_upgrade!
      end.should raise_error(GameLogicError)
    end

    it "should not fail if not repairing" do
      b = Factory.build(:b_repairable_test, :state => Building::STATE_ACTIVE)
      lambda do
        b.check_upgrade!
      end.should_not raise_error(GameLogicError)
    end
  end

  describe "#repair!" do
    let(:player) { Factory.create(:player) }
    let(:planet) do
      p = Factory.create(:planet, :player => player)
      set_resources(p, 10000, 10000, 10000)
      p
    end
    let(:building) do
      Factory.create(:b_repairable_test, opts_active + {
        :planet => planet, :hp_percentage => 0.32})
    end
    let(:technology) do
      Factory.create!(:t_building_repair, :player => player, :level => 1)
    end

    # Create technology.
    before(:each) { technology }

    it "should fail if planet has no owner" do
      planet.player = nil
      planet.save!

      lambda do
        building.repair!
      end.should raise_error(GameLogicError)
    end
    
    it "should fail if player does not have building repair technology" do
      technology.destroy

      lambda do
        building.repair!
      end.should raise_error(GameLogicError)
    end

    it "should fail if player has level 0 technology" do
      technology.level = 0
      technology.save!

      lambda do
        building.repair!
      end.should raise_error(GameLogicError)
    end

    it "should fail unless building is active" do
      building.state = Building::STATE_INACTIVE

      lambda do
        building.repair!
      end.should raise_error(GameLogicError)
    end

    it "should fail if planet does not have enough resources" do
      planet.metal, planet.energy, planet.zetium = technology.
        resources_for_healing(building).map { |amount| amount - 1 }
      planet.save!

      lambda do
        building.repair!
      end.should raise_error(GameLogicError)
    end

    it "should reduce resources from planet" do
      metal, energy, zetium = technology.resources_for_healing(building)
      expected = [
        planet.metal - metal,
        planet.energy - energy,
        planet.zetium - zetium
      ]

      building.repair!
      planet.reload
      [planet.metal, planet.energy, planet.zetium].should == expected
    end

    it "should set cooldown on building" do
      ends_at = technology.healing_time(building.damaged_hp).seconds.from_now
      building.repair!
      building.reload
      building.cooldown_ends_at.should be_within(SPEC_TIME_PRECISION).
                                         of(ends_at)
    end

    it "should change state to repairing" do
      lambda do
        building.repair!
        building.reload
      end.should change(building, :state).from(Building::STATE_ACTIVE).
        to(Building::STATE_REPAIRING)
    end

    it "should fire updated on building" do
      should_fire_event(building, EventBroker::CHANGED) do
        building.repair!
      end
    end

    it "should fire updated on planet" do
      should_fire_event(planet, EventBroker::CHANGED,
          EventBroker::REASON_OWNER_PROP_CHANGE) do
        building.repair!
      end
    end

    it "should progress RepairHp objective" do
      Objective::RepairHp.should_receive(:progress).
        with(player, building.damaged_hp)
      building.repair!
    end

    it "should register callback" do
      building.repair!
      building.should have_callback(CallbackManager::EVENT_COOLDOWN_EXPIRED,
                        building.cooldown_ends_at)
    end
  end

  describe "#on_repairs_finished!" do
    let(:building) do
      Factory.create(
        :b_repairable_test,
        :hp_percentage => 0.34,
        :state => Building::STATE_REPAIRING,
        :cooldown_ends_at => 87.minutes.from_now
      )
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
      building = Factory.create(:b_repairable_test)
      Building::RepairableTest.stub(:find).with(building.id).
        and_return(building)
      building.should_receive(:on_repairs_finished!)

      Building::RepairableTest.on_callback(building.id,
        CallbackManager::EVENT_COOLDOWN_EXPIRED)
    end
  end
end