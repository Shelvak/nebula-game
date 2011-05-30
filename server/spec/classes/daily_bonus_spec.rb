require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe DailyBonus do
  describe ".get_range" do
    before(:all) do
      @ranges = [
        ["range1", 0, 500],
        ["range2", 500, 1000],
        ["range3", 1000, nil],
      ]
    end
  
    it "should return level from points" do
      with_config_values('daily_bonus.ranges' => @ranges) do
        DailyBonus.send(:get_range, 300).should == "range1"
      end
    end
    
    it "should have end number exclusive" do
      with_config_values('daily_bonus.ranges' => @ranges) do
        DailyBonus.send(:get_range, 500).should == "range2"
      end
    end
    
    it "should support nil end range" do
      with_config_values('daily_bonus.ranges' => @ranges) do
        DailyBonus.send(:get_range, 2000).should == "range3"
      end
    end
  end
  
  describe ".get_bonus" do
    before(:each) do
      @ranges = [
        ["range1", 0, nil]
      ]
    end
    
    it "should return Rewards" do
      DailyBonus.get_bonus(10, 300).should be_instance_of(Rewards)
    end
    
    it "should support units" do
      with_config_values(
        'daily_bonus.ranges' => @ranges,
        'daily_bonus.range.range1' => [['unit', 'Trooper', 3]]
      ) do
        rewards = Rewards.new
        rewards.add_unit(Unit::Trooper, :level => 3)
        DailyBonus.get_bonus(10, 300).should == rewards
      end
    end
    
    %w{creds metal energy zetium}.each do |type|
      it "should support #{type}" do
        with_config_values(
          'daily_bonus.ranges' => @ranges,
          'daily_bonus.range.range1' => [[type, 3000]]
        ) do
          rewards = Rewards.new
          rewards.send("add_#{type}", 3000)
          DailyBonus.get_bonus(10, 300).should == rewards
        end
      end
    end
  end
end