require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe Cfg do
  describe ".folliage_removal_cost" do
    it "should return rounded number" do
      with_config_values(
        "creds.folliage.remove" => "1.0 * width * height * 0.33"
      ) do
        Cfg.folliage_removal_cost(4, 5).should == 7
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
end