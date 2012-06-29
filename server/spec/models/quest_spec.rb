require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Quest do
  describe "#as_json" do
    it "should return Hash" do
      quest = Factory.create(:quest)
      quest.as_json.should == {
        :id => quest.id,
        :rewards => quest.rewards.as_json,
        :main_quest_slides => quest.main_quest_slides,
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
      @result.find { |quest_hash| quest_hash[:quest] == @quest1.as_json }[
        :objectives
      ].map { |objective_hash| objective_hash[:objective] }.
        should == [@obj1.as_json, @obj2.as_json]
    end

    it "should include objective progresses" do
      @result.find { |quest_hash| quest_hash[:quest] == @quest1.as_json }[
        :objectives
      ].find { |objective_hash| objective_hash[:objective] == @obj1.as_json }[
        :progress
      ].should == @objp1.as_json
    end

    it "should be nil where objective has been finished" do
      @result.find { |quest_hash| quest_hash[:quest] == @quest1.as_json }[
        :objectives
      ].find { |objective_hash| objective_hash[:objective] == @obj2.as_json }[
        :progress
      ].should == nil.as_json
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

  describe ".start_player_quest_line" do
    let(:parent_quest) { Factory.create(:quest, parent: nil) }
    let(:parent_qp_scope) do
      QuestProgress.where(player_id: player.id, quest_id: parent_quest.id)
    end
    let(:parent_objective) { Factory.create(:objective, quest: parent_quest) }
    let(:parent_op_scope) do
      ObjectiveProgress.
        where(player_id: player.id, objective_id: parent_objective.id)
    end
    let(:child_quest) { Factory.create(:quest, parent: parent_quest) }
    let(:child_qp_scope) do
      QuestProgress.where(player_id: player.id, quest_id: child_quest.id)
    end
    let(:child_objective) { Factory.create(:objective, quest: child_quest) }
    let(:child_op_scope) do
      ObjectiveProgress.
        where(player_id: player.id, objective_id: child_objective.id)
    end
    let(:player) { Factory.create(:player) }

    before(:each) { parent_objective; child_objective }

    it "should create QuestProgress for parent quest" do
      lambda do
        Quest.start_player_quest_line(player.id)
      end.should change(parent_qp_scope, :count).from(0).to(1)
    end

    it "should set QuestProgress#status to started" do
      Quest.start_player_quest_line(player.id)
      parent_qp_scope.first.status.should == QuestProgress::STATUS_STARTED
    end

    it "should set QuestProgress#completed to 0" do
      Quest.start_player_quest_line(player.id)
      parent_qp_scope.first.completed.should == 0
    end

    it "should create ObjectiveProgress for parent quest" do
      lambda do
        Quest.start_player_quest_line(player.id)
      end.should change(parent_op_scope, :count).from(0).to(1)
    end

    it "should set ObjectiveProgress#completed to 0" do
      Quest.start_player_quest_line(player.id)
      parent_op_scope.first.completed.should == 0
    end

    it "should not create QuestProgress for child quest" do
      lambda do
        Quest.start_player_quest_line(player.id)
      end.should_not change(child_qp_scope, :count).from(0)
    end

    it "should not create ObjectiveProgress for child quest" do
      lambda do
        Quest.start_player_quest_line(player.id)
      end.should_not change(child_op_scope, :count).from(0)
    end
  end
end