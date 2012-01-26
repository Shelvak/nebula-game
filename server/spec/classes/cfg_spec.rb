require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe Cfg do
  describe ".galaxy_zone_death_age" do
    it "should return a number" do
      Cfg.galaxy_zone_death_age(3).should be_instance_of(Fixnum)
    end
  end

  describe ".foliage_removal_cost" do
    it "should return rounded number" do
      with_config_values(
        "creds.foliage.remove" => "1.0 * width * height * 0.33"
      ) do
        Cfg.foliage_removal_cost(4, 5).should == 7
      end
    end
  end
  
  describe ".exploration_finish_cost" do
    it "should return rounded number" do
      with_config_values(
        "creds.exploration.finish" => "1.0 * width * height * 0.33"
      ) do
        Cfg.exploration_finish_cost(4, 5).should == 7
      end
    end
  end

  describe ".planet_protection_duration" do
    let(:galaxy) { Factory.build(:galaxy) }

    it "should return one key when galaxy is not finished" do
      expected = CONFIG.evalproperty(
        'combat.cooldown.protection.duration'
      )
      Cfg.planet_protection_duration(galaxy).
        should be_within(SPEC_TIME_PRECISION).of(expected)
    end

    it "should return other key when galaxy is finished" do
      galaxy.stub(:finished?).and_return(true)
      expected = CONFIG.evalproperty(
        'combat.cooldown.protection.finished_galaxy.duration'
      )
      Cfg.planet_protection_duration(galaxy).
        should be_within(SPEC_TIME_PRECISION).of(expected)
    end
  end

  describe ".market_bot_random_resource" do
    it "should return item from range multiplied by time multiplier" do
      kind = MarketOffer::KIND_METAL
      multiplier = 105
      galaxy_id = 10

      range = Cfg.market_bot_resource_range(kind) * multiplier
      Cfg.should_receive(:market_bot_resource_multiplier).with(galaxy_id).
        and_return(multiplier)
      range.should cover(Cfg.market_bot_random_resource(galaxy_id, kind))
    end
  end

  describe ".player_inactivity_time" do
    let(:key) { 'galaxy.player.inactivity_check' }
    let(:value) { [[1, 1.minute], [100, 5.minutes], [1000, 10.minutes]] }

    it "should return found seconds" do
      with_config_values(key => value) do
        Cfg.player_inactivity_time(50).should == 5.minutes
      end
    end

    it "should return last value if points are too large" do
      with_config_values(key => value) do
        Cfg.player_inactivity_time(1500).should == 10.minutes
      end
    end
  end

  describe ".market_bot_resource_multiplier" do
    let(:divider) { Cfg.market_bot_resource_day_divider }

    it "should return 1 if galaxy is still young" do
      galaxy = Factory.create(:galaxy, :created_at => (divider - 1).days.ago)
      Cfg.market_bot_resource_multiplier(galaxy.id).should == 1
    end

    it "should return a Float if galaxy is old enough" do
      galaxy = Factory.create(:galaxy, :created_at => (divider + 28).days.ago)
      Cfg.market_bot_resource_multiplier(galaxy.id).should be_within(0.01).of(
        (divider + 28) / divider.to_f
      )
    end
  end
end