require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe CombatLog do
  before(:all) do
    @log_report = {
      :info => {
        :player_count => 10,
        :alliances => [
          [
            {:id => 10, :name => "orc"},
            {:id => 11, :name => "undead"}
          ],
          [
            {:id => 20, :name => "human"},
            {:id => 21, :name => "night elf"}
          ]
        ],
        :winner_index => 1
      }
    }
  end

  describe "#winner?" do
    it "should return true if player is a winner" do
      CombatLog.winner?(@log_report[:info], 20).should be_true
    end

    it "should return false if player is not a winner" do
      CombatLog.winner?(@log_report[:info], 10).should be_false
    end

    it "should return false if there was a tie" do
      CombatLog.winner?(
        @log_report[:info].merge(:winner_index => nil), 20
      ).should be_false
    end
  end

  describe ".create_from_combat!" do
    it "should generate an id of length 40" do
      CombatLog.create_from_combat!(
        @log_report[:info]
      ).id.length.should == 40
    end

    it "should set info to log as json" do
      CombatLog.create_from_combat!(
        @log_report[:info]
      ).info.should == @log_report[:info].to_json
    end

    it "should set expires_at" do
      CombatLog.create_from_combat!(
        @log_report[:info]
      ).expires_at.to_s(:db).should == (
        Time.now + CONFIG['notifications.expiration_time']
      ).to_s(:db)
    end

    it "should return saved object" do
      CombatLog.create_from_combat!(
        @log_report[:info]
      ).should_not be_new_record
    end
  end
end