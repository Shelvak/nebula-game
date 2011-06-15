require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Objective::CompleteQuests do
  describe "#initial_completed" do
    before(:each) do
      @player = Factory.create(:player)
      # We need large count to not to trigger quests completed.
      @objective = Factory.create(:o_complete_quests, :count => 1000)
      Factory.create(:quest_progress, player: @player,
        status: QuestProgress::STATUS_COMPLETED)
      Factory.create(:quest_progress, player: @player,
        status: QuestProgress::STATUS_REWARD_TAKEN)
    end

    it "should count quests" do
      @objective.initial_completed(@player.id).should == 2
    end

    it "should not count achievements" do
      achievement = Factory.create(:achievement)
      Factory.create(:quest_progress, player: @player,
        status: QuestProgress::STATUS_COMPLETED,
        quest: achievement)
      @objective.initial_completed(@player.id).should == 2
    end

    it "should only count that players quests" do
      Factory.create(:quest_progress, player: Factory.create(:player),
        status: QuestProgress::STATUS_COMPLETED)
      @objective.initial_completed(@player.id).should == 2
    end

    it "should not count incomplete quests" do
      # We need at least one objective because quest autocompletes itself.
      objective = Factory.create(:objective)
      Factory.create(:quest_progress, :player => @player,
          :quest => objective.quest)
      @objective.initial_completed(@player.id).should == 2
    end
  end

  describe ".progress" do
    it "should not progress complete achievements objective" do
      objective = Factory.create(:o_complete_achievements, :count => 20)
      op = Factory.create(:objective_progress, :objective => objective)
      qp = Factory.create(:quest_progress, :player => op.player)
      lambda do
        Objective::CompleteQuests.progress(qp)
        op.reload
      end.should_not change(op, :completed)
    end
  end
end
