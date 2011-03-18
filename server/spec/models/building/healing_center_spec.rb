require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::HealingCenter do
  describe "#resources_for_healing" do
    it "should return resources" do
      building = Factory.build(:b_healing_center, :level => 1)
      unit = Factory.build(:u_crow, :level => 1, :hp => 100)
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
      b = Factory.build(:b_healing_center, :level => 2)
      with_config_values(
        'buildings.healing_center.healing.cost.mod' => '10 - 2 * level'
      ) do
        b.cost_modifier.should == 6
      end
    end
  end

  describe "#healing_time" do
    it "should return ceiled values" do
      b = Factory.build(:b_healing_center, :level => 2)
      with_config_values(
        'buildings.healing_center.healing.time.mod' => 
          '(0.35 - 0.1 * level) / speed'
      ) do
        b.healing_time(10).should == 2
      end
    end
  end

  describe "#as_json" do
    before(:each) do
      @model = Factory.build(:b_healing_center)
    end

    @required_fields = %w{cooldown_ends_at}
    it_should_behave_like "to json"
  end

  describe "#heal!" do
    before(:each) do
      @planet = Factory.create(:planet)
      set_resources(@planet, 100000, 100000, 100000)
      @hp_diff = Unit::Crow.hit_points(1) / 2
      @unit = Factory.create(:u_crow, :level => 1,
        :hp => @hp_diff, :location => @planet)
      @units = [@unit]
      @building = Factory.create!(:b_healing_center, :planet => @planet,
        :level => 1, :state => Building::STATE_ACTIVE)
    end

    it "should raise error if it's state is not active" do
      @building.state = Building::STATE_WORKING
      @building.save!

      lambda do
        @building.heal!(@units)
      end.should raise_error(GameLogicError)
    end

    it "should raise error if cooldown hasn't expired yet" do
      @building.cooldown_ends_at = 10.minutes.from_now
      @building.save!

      lambda do
        @building.heal!(@units)
      end.should raise_error(GameLogicError)
    end

    it "should raise error if any of the units is not in planet" do
      @unit.location = @planet.solar_system_point
      @unit.save!

      lambda do
        @building.heal!(@units)
      end.should raise_error(GameLogicError)
    end

    it "should set cooldown_ends_at" do
      time = @building.healing_time(
        @unit.hit_points - @unit.hp).seconds.from_now
      @building.heal!(@units)
      @building.reload
      @building.cooldown_ends_at.should be_close(time, SPEC_TIME_PRECISION)
    end

    %w{metal energy zetium}.each_with_index do |resource, index|
      it "should raise error if there are not enough #{resource}" do
        @planet.send("#{resource}=",
          @building.resources_for_healing(@unit)[index] - 10)
        @planet.save!

        lambda do
          @building.heal!(@units)
        end.should raise_error(GameLogicError)
      end

      it "should reduce #{resource} from planet" do
        need = @building.resources_for_healing(@unit)[index]

        lambda do
          @building.heal!(@units)
          @planet.reload
        end.should change(@planet, resource).by(- need)
      end
    end

    it "should restore unit hp to 100%" do
      @building.heal!(@units)
      @unit.reload
      @unit.hp.should == @unit.hit_points
    end
    
    it "should dispatch building" do
      should_fire_event(@building, EventBroker::CHANGED) do
        @building.heal!(@units)
      end
    end

    it "should dispatch units" do
      should_fire_event(@units, EventBroker::CHANGED) do
        @building.heal!(@units)
      end
    end

    it "should dispatch planet" do
      should_fire_event(@planet, EventBroker::CHANGED) do
        @building.heal!(@units)
      end
    end
  end
end