require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe Cfg do
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
end