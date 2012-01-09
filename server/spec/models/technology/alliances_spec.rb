require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Technology::Alliances do
  describe ".required_level_for_player_count" do
    it "should return a number" do
      with_config_values(
        "technologies.alliances.max_players" => "level * 3"
      ) do
        Technology::Alliances.required_level_for_player_count(4).should == 2
      end
    end
  end
end