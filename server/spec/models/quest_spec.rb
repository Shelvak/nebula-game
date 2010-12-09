require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Quest do
  describe "#as_json" do
    it "should return Hash" do
      quest = Factory.create(:quest)
      quest.as_json.should == {
        :id => quest.id,
        :rewards => quest.rewards.as_json,
        :help_url_id => quest.help_url_id,
      }
    end
  end

  describe ".hash_all_for_player_id" do
    before(:all) do
      @player = Factory.create(:player)

      @quest1 = Factory.create(:quest)
      @questp1 = Factory.create(:quest_progress, :quest => @quest1,
        :status => QuestProgress::STATUS_STARTED, :player => @player)
      @obj1 = Factory.create(:objective, :quest => @quest1, :count => 5)
      @objp1 = Factory.create(:objective_progress, :objective => @obj1,
        :completed => 2, :player => @player)
      @obj2 = Factory.create(:objective, :quest => @quest1, :count => 10)

      @quest2 = Factory.create(:quest)
      
      @quest3 = Factory.create(:quest)
      @questp3 = Factory.create(:quest_progress, :quest => @quest3,
        :status => QuestProgress::STATUS_REWARD_TAKEN, :player => @player)

      @quest4 = Factory.create(:quest)
      @questp4 = Factory.create(:quest_progress, :quest => @quest4,
        :status => QuestProgress::STATUS_STARTED, :player => @player)

      @result = Quest.hash_all_for_player_id(@player.id)
    end

    it "should return started quests" do
      @result.reject do |quest_hash|
        ! [@quest1, @quest4].include?(quest_hash[:quest])
      end.should_not be_blank
    end

    it "should include their objectives" do
      @result.find do |quest_hash|
        quest_hash[:quest] == @quest1
      end[:objectives].map do |objective_hash|
        objective_hash[:objective]
      end.should == [@obj1, @obj2]
    end

    it "should include objective progresses" do
      @result.find do |quest_hash|
        quest_hash[:quest] == @quest1
      end[:objectives].find do |objective_hash|
        objective_hash[:objective] == @obj1
      end[:progress].should == @objp1
    end

    it "should be nil where objective has been finished" do
      @result.find do |quest_hash|
        quest_hash[:quest] == @quest1
      end[:objectives].find do |objective_hash|
        objective_hash[:objective] == @obj2
      end[:progress].should be_nil
    end

    it "should not return not started quests" do
      @result.find do |quest_hash|
        quest_hash[:quest] == @quest2
      end.should be_nil
    end

    it "should return quests with claimed reward" do
      @result.find do |quest_hash|
        quest_hash[:quest] == @quest3
      end.should_not be_nil
    end
  end
end