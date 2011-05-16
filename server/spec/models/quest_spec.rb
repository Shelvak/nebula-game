require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

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

      @achievement = Factory.create(:achievement)
      @achievementp = Factory.create(:quest_progress, :quest => @achievement,
        :status => QuestProgress::STATUS_STARTED, :player => @player)

      @result = Quest.hash_all_for_player_id(@player.id)
    end

    it "should return started quests" do
      @result.reject do |quest_hash|
        ! [@quest1.as_json, @quest4.as_json].include?(quest_hash[:quest])
      end.should_not be_blank
    end

    it "should include their objectives" do
      @result.find do |quest_hash|
        quest_hash[:quest] == @quest1.as_json
      end[:objectives].map do |objective_hash|
        objective_hash[:objective]
      end.should == [@obj1.as_json, @obj2.as_json]
    end

    it "should include objective progresses" do
      @result.find do |quest_hash|
        quest_hash[:quest] == @quest1.as_json
      end[:objectives].find do |objective_hash|
        objective_hash[:objective] == @obj1.as_json
      end[:progress].should == @objp1.as_json
    end

    it "should be nil where objective has been finished" do
      @result.find do |quest_hash|
        quest_hash[:quest] == @quest1.as_json
      end[:objectives].find do |objective_hash|
        objective_hash[:objective] == @obj2.as_json
      end[:progress].should == nil.as_json
    end

    it "should not return not started quests" do
      @result.find do |quest_hash|
        quest_hash[:quest] == @quest2.as_json
      end.should be_nil
    end

    it "should not include achievements" do
      @result.find do |quest_hash|
        quest_hash[:quest] == @achievement.as_json
      end.should be_nil
    end

    it "should return quests with claimed reward" do
      @result.find do |quest_hash|
        quest_hash[:quest] == @quest3.as_json
      end.should_not == nil.as_json
    end
  end

  describe ".achievements_for_player_id" do
    before(:each) do
      Quest.delete_all
    end

    it "should not include quests" do
      Factory.create(:quest)
      Quest.achievements_by_player_id(1).should == []
    end

    it "should include completion status" do
      achievement = Factory.create(:achievement)
      qp = Factory.create(:quest_progress,
        :quest => achievement,
        :player => Factory.create(:player),
        :status => QuestProgress::STATUS_COMPLETED)
      Quest.achievements_by_player_id(qp.player_id)[0]["completed"].should \
        be_true
    end

    it "should include objective columns" do
      achievement = Factory.create(:achievement)
      obj = Factory.create(:objective, :quest => achievement)
      row = Quest.achievements_by_player_id(1)[0]

      cols = (Objective.columns.map(&:name) - %w{id quest_id})
      Hash[cols.map { |col| [col, row[col]] }].should equal_to_hash(
        Hash[cols.map { |col| [col, obj.send(col)] }]
      )
    end
  end

  describe ".achievement" do
    it "should return achievement id if given" do
      Factory.create(:achievement)
      achievement = Factory.create(:achievement)
      achievement_row = Quest.achievements_by_player_id(1, achievement.id)[0]
      Quest.get_achievement(achievement.id, 1).should == achievement_row
    end

    it "should raise AR::RecordNotFound if no such achievement exists" do
      lambda do
        Quest.get_achievement(0)
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end
end