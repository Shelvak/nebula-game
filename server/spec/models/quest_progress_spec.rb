require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

shared_examples_for "completed quest" do
  it "should change status to COMPLETED" do
    lambda do
      @qp.save!
    end.should change(@qp, :status).from(
      QuestProgress::STATUS_STARTED
    ).to(QuestProgress::STATUS_COMPLETED)
  end

  it "should start child quests" do
    @qp.save!
    QuestProgress.where(
      :player_id => @qp.player_id, :quest_id => @child_quest.id,
      :status => QuestProgress::STATUS_STARTED
    ).first.should_not be_nil
  end

  describe "achievement" do
    before(:each) do
      @qp.quest.achievement = true
      @qp.quest.save!
    end


    it "should create notification for achievement completed" do
      Notification.should_receive(:create_for_achievement_completed).
        with(@qp)
      @qp.save!
    end

    it "should progress complete achievements" do
      Objective::CompleteAchievements.should_receive(:progress).
        with(@qp)
      @qp.save!
    end
  end

  it "should create notification for quest completed" do
    Quest.stub!(:start_child_quests).and_return(:quests)
    Notification.should_receive(:create_for_quest_completed).
      with(@qp, :quests)
    @qp.save!
  end

  it "should progress complete achievements" do
    Objective::CompleteQuests.should_receive(:progress).
      with(@qp)
    @qp.save!
  end
end

describe QuestProgress do
  describe "object" do
    before(:all) do
      @class = QuestProgress
    end

    it_behaves_like "object"
  end

  describe "creation" do
    it "should copy objective progresses" do
      quest = Factory.create :quest
      objective1 = Factory.create :o_upgrade_to, :quest => quest,
        :key => "Unit::Trooper", :count => 2, :level => 1
      objective2 = Factory.create :o_upgrade_to, :quest => quest,
        :key => "Unit::Shocker", :count => 3, :level => 1

      qp = Factory.create :quest_progress, :quest => quest
      ObjectiveProgress.where(
        :objective_id => [objective1.id, objective2.id],
        :player_id => qp.player_id
      ).size.should == 2
    end

    it "should set initial completed count" do
      quest = Factory.create :quest
      objective = Factory.create :o_have_upgraded_to, :quest => quest,
        :key => "Unit::Trooper", :count => 2, :level => 1

      @planet = Factory.create(:player)
      Factory.create(:u_trooper, :player => @planet, :level => 1)
      qp = Factory.create :quest_progress, :quest => quest,
        :player => @planet

      ObjectiveProgress.where(
        :objective_id => objective.id,
        :player_id => qp.player_id
      ).first.completed.should == 1
    end

    it "should fire created with ClientQuest" do
      qp = Factory.build(:quest_progress)
      should_fire_event(
          an_instance_of(ClientQuest), EventBroker::CREATED) do
        qp.save!
      end
    end

    describe "when quest progress is created already completed" do
      before(:each) do
        @quest = Factory.create(:quest)
        Factory.create(:objective, :quest => @quest)
        @child_quest = Factory.create(:quest, :parent => @quest)
        Factory.create(:objective, :quest => @child_quest)

        @qp = Factory.build(:quest_progress, :completed => 1,
          :quest => @quest)
      end

      it_behaves_like "completed quest"

      it "should first dispatch created and then do #on_quest_completed" do
        @qp.should_receive(:dispatch_client_quest).ordered.and_return(true)
        @qp.should_receive(:on_quest_completed).ordered.and_return(true)
        @qp.save!
      end
    end

    describe "when one of quest objectives is already completed" do
      before(:each) do
        @quest = Factory.create(:quest)
        @obj = Factory.create(:o_have_upgraded_to, :quest => @quest)
        Factory.create(:objective, :quest => @quest)

        @player = Factory.create(:player)
        Factory.create(:unit_built, :player => @player)
        @qp = Factory.create(:quest_progress, :player => @player,
          :quest => @quest)
      end

      it "should not create objective progress" do
        ObjectiveProgress.where(:player_id => @player.id,
          :objective_id => @obj).count.should == 0
      end

      it "should increase completed" do
        @qp.completed.should == 1
      end
    end
  end

  describe "when completed == quest.objectives.size" do
    before(:each) do
      @quest = Factory.create(:quest)
      Factory.create(:objective, :quest => @quest)
      Factory.create(:objective, :quest => @quest)

      @child_quest = Factory.create(:quest, :parent => @quest)
      Factory.create(:objective, :quest => @child_quest)

      @qp = Factory.create(:quest_progress, :quest => @quest)
      @qp.completed = 2
    end

    it_behaves_like "completed quest"
  end

  describe "#claim_rewards!" do
    before(:each) do
      @rewards = Rewards.new
      @quest = Factory.create(:quest, :rewards => @rewards)
      @qp = Factory.create :quest_progress, :quest => @quest,
        :status => QuestProgress::STATUS_COMPLETED
      @player = @qp.player
      @planet = Factory.create :planet_with_player, :player => @player
    end

    it "should fail if reward is already taken" do
      @qp.status = QuestProgress::STATUS_REWARD_TAKEN
      lambda do
        @qp.claim_rewards!(@planet.id)
      end.should raise_error(GameLogicError)
    end
    
    it "should fail if quest is not completed" do
      @qp.status = QuestProgress::STATUS_STARTED
      lambda do
        @qp.claim_rewards!(@planet.id)
      end.should raise_error(GameLogicError)
    end

    it "should fail if there is no rewards" do
      @quest.rewards = nil
      @quest.save!

      lambda do
        @qp.claim_rewards!(@planet.id)
      end.should raise_error(GameLogicError)
    end

    it "should change status" do
      lambda do
        @qp.claim_rewards!(@planet.id)
        @qp.reload
      end.should change(@qp, :status).to(QuestProgress::STATUS_REWARD_TAKEN)
    end

    it "should fail if planet doesn't belong to player" do
      lambda do
        @qp.claim_rewards!(Factory.create(:planet).id)
      end.should raise_error(GameLogicError)
    end

    it "should call rewards.claim!" do
      @qp.quest.stub!(:rewards).and_return(@rewards)
      @rewards.should_receive(:claim!).with(@planet, @player)
      @qp.claim_rewards!(@planet.id)
    end
  end

  describe "notifier" do
    build = lambda { Factory.create(:quest_progress) }
    after_build = lambda do |model|
      Factory.create(:objective, :quest => model.quest)
      Factory.create(:objective, :quest => model.quest)
    end
    change = lambda { |model| model.completed += 1 }

    it_behaves_like "notifier", :build => build, :after_build => after_build,
      :change => change, :notify_on_create => false, :notify_on_destroy => false

    describe "for achievement" do
      before(:each) do
        @model = build.call.tap(&:save!)
        after_build.call(@model)
        quest = @model.quest
        quest.achievement = true
        quest.save!
      end

      it "should not dispatch updated" do
        should_not_fire_event(@model, EventBroker::CHANGED,
            EventBroker::REASON_UPDATED) do
          change.call(@model)
          @model.save!
        end
      end
    end
  end
end