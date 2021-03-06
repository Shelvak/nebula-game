require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe Cfg do
  describe ".next_convoy_time" do
    it "should not fail if there are no wormholes in galaxy" do
      Cfg.next_convoy_time(0)
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

  describe ".solar_system_spawn_key" do
    it "should return 'home' for home ss" do
      Cfg.solar_system_spawn_key(Factory.build(:home_ss)).
        should == "solar_system.spawn.home"
    end

    it "should return 'regular' for normal ss" do
      Cfg.solar_system_spawn_key(Factory.build(:solar_system)).
        should == "solar_system.spawn.regular"
    end

    it "should return 'battleground' for battleground ss" do
      Cfg.solar_system_spawn_key(Factory.build(:battleground)).
        should == "solar_system.spawn.battleground"
    end

    it "should return 'mini_battleground' for pulsar ss" do
      Cfg.solar_system_spawn_key(Factory.build(:mini_battleground)).
        should == "solar_system.spawn.mini_battleground"
    end

    it "should raise ArgumentError for others" do
      lambda do
        Cfg.solar_system_spawn_key(Factory.build(:wormhole))
      end.should raise_error(ArgumentError)
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
    let(:value) { [
      [1, "#{1.minute} / speed"],
      [100, "#{5.minutes} / speed"],
      [1000, "#{10.minutes} / speed"]
    ] }

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

    it "should eval formula with speed" do
      with_config_values(key => value, 'speed' => 5) do
        Cfg.player_inactivity_time(1500).should == 2.minutes
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

  describe ".creds_upgradable_speed_up_entry" do
    it "should return ArgumentError if index is out of bounds" do
      lambda do
        Cfg.creds_upgradable_speed_up_entry(
          CONFIG['creds.upgradable.speed_up'].size
        )
      end.should raise_error(ArgumentError)
    end

    it "should return evaled time" do
      Cfg.creds_upgradable_speed_up_entry(0)[0].
        should == CONFIG.safe_eval(CONFIG['creds.upgradable.speed_up'][0][0])
    end

    it "should return cost" do
      Cfg.creds_upgradable_speed_up_entry(0)[1].
        should == CONFIG['creds.upgradable.speed_up'][0][1]
    end
  end

  describe "Java" do
    describe ".fairnessPoints" do
      it "should use the formula" do
        formula = "economy * 2 + science * 4 + army * 6 + war * 8 + victory * 9"
        with_config_values("combat.battle.fairness_points" => formula) do
          e, s, a, w, v = 10, 20, 30, 40, 50

          Cfg::Java.fairnessPoints(e, s, a, w, v).should == CONFIG.safe_eval(
            formula, {"economy" => e, "science" => s, "army" => a, "war" => w,
              "victory" => v}
          )
        end
      end
    end
  end

  describe "ss_object" do
    let(:battleground) { Factory.create(:battleground) }
    let(:mini_battleground) { Factory.create(:mini_battleground) }
    let(:home_ss) { Factory.create(:home_ss) }

    describe "#planet_boss_spawn_key" do
      describe "battleground" do
        it "should return battleground key" do
          Cfg.planet_boss_spawn_key(battleground).
            should == 'ss_object.spawn.battleground'
        end
      end

      describe "mini battleground" do
        it "should return mini battleground key" do
          Cfg.planet_boss_spawn_key(mini_battleground).
            should == 'ss_object.spawn.mini_battleground'
        end
      end

      describe "other" do
        it "should raise error" do
          lambda do
            Cfg.planet_boss_spawn_key(home_ss)
          end.should raise_error(ArgumentError)
        end
      end
    end

    describe "#planet_boss_spawn_definition" do
      it "should call #planet_boss_spawn_key and return appropriate units" do
        Cfg.should_receive(:planet_boss_spawn_key).
          and_return("ss_object.spawn.battleground")
        Cfg.planet_boss_spawn_definition(battleground).
          should == CONFIG['ss_object.spawn.battleground.units']
      end
    end

    describe "#planet_boss_spawn_delay_range" do
      it "should return range" do
        range = Cfg.planet_boss_spawn_delay_range(battleground)
        [range.first, range.last].should == [
          CONFIG.safe_eval(CONFIG['ss_object.spawn.battleground.delay'][0]),
          CONFIG.safe_eval(CONFIG['ss_object.spawn.battleground.delay'][1])
        ]
      end
    end

    describe "#planet_boss_spawn_random_delay" do
      it "should return delay in seconds" do
        range = Cfg.planet_boss_spawn_delay_range(battleground)
        range.should include(Cfg.planet_boss_spawn_random_delay(battleground))
      end
    end

    describe "#planet_boss_spawn_random_delay_date" do
      it "should return future date" do
        range = Cfg.planet_boss_spawn_delay_range(battleground)
        date = Cfg.planet_boss_spawn_random_delay_date(battleground)
        date.should >= (range.first - SPEC_TIME_PRECISION).from_now
        date.should <= (range.last + SPEC_TIME_PRECISION).from_now
      end
    end
  end
end