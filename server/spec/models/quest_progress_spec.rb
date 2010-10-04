require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe QuestProgress do
  describe "object" do
    before(:all) do
      @class = QuestProgress
    end

    it_should_behave_like "object"
  end

  describe "creation" do
    it "should copy objective progresses" do
      quest = Factory.create :quest
      objective1 = Factory.create :o_upgrade_to, :quest => quest,
        :key => "Unit::Trooper", :count => 2, :level => 1
      objective2 = Factory.create :o_upgrade_to, :quest => quest,
        :key => "Unit::Shocker", :count => 3, :level => 1

      qp = Factory.create :quest_progress, :quest => quest
      ObjectiveProgress.count(:all, :conditions => {
        :objective_id => [objective1.id, objective2.id],
        :player_id => qp.player_id
      }).should == 2
    end

    it "should create notification" do
      qp = Factory.build(:quest_progress)
      Notification.should_receive(:create_for_quest_started).with(qp)
      qp.save!
    end

    it "should fire created with ClientQuest" do
      qp = Factory.build(:quest_progress)
      should_fire_event(
          an_instance_of(ClientQuest), EventBroker::CREATED) do
        qp.save!
      end
    end
  end

  describe "when completed == quest.objectives.size" do
    before(:each) do
      @qp = Factory.create(:quest_progress)
      Factory.create(:objective, :quest => @qp.quest)
      Factory.create(:objective, :quest => @qp.quest)
      @child_quest = Factory.create(:quest, :parent => @qp.quest)
      Factory.create(:objective, :quest => @child_quest)
      @qp.completed = 2
    end

    it "should change status to COMPLETED" do
      lambda do
        @qp.save!
      end.should change(@qp, :status).to(QuestProgress::STATUS_COMPLETED)
    end

    it "should start child quests" do
      @qp.save!
      QuestProgress.find(:first, :conditions => {
        :player_id => @qp.player_id, :quest_id => @child_quest.id,
        :status => QuestProgress::STATUS_STARTED}
      ).should_not be_nil
    end

    it "should create notification" do
      Notification.should_receive(:create_for_quest_completed).with(@qp)
      @qp.save!
    end
  end

  describe "#claim_rewards!" do
    before(:each) do
      metal = 100
      energy = 110
      zetium = 120

      @quest = Factory.create(:quest, :rewards => {
          Quest::REWARD_ENERGY => energy,
          Quest::REWARD_METAL => metal,
          Quest::REWARD_ZETIUM => zetium,
          Quest::REWARD_XP => 130,
          Quest::REWARD_POINTS => 140,
          Quest::REWARD_UNITS => [
            {'type' => "Trooper", 'level' => 1, 'count' => 2},
            {'type' => "Shocker", 'level' => 2, 'count' => 1}
          ]
        })
      @qp = Factory.create :quest_progress, :quest => @quest,
        :status => QuestProgress::STATUS_COMPLETED
      @planet = Factory.create :planet_with_player, :player => @qp.player
      player = @planet.resources_entry
      player.metal_storage += metal
      player.energy_storage += energy
      player.zetium_storage += zetium
      player.save!
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

    QuestProgress::REWARD_RESOURCES.each do |type, reward|
      it "should reward #{type}" do
        model = @planet.resources_entry
        lambda do
          @qp.claim_rewards!(@planet.id)
          model.reload
        end.should change(model, type).by(@quest.rewards[reward])
      end
    end

    it "should fire changed on ResourcesEntry" do
      should_fire_event(@planet.resources_entry, EventBroker::CHANGED) do
        @qp.claim_rewards!(@planet.id)
      end
    end

    QuestProgress::REWARD_PLAYER.each do |type, reward|
      it "should reward #{type}" do
        player = @qp.player
        lambda do
          @qp.claim_rewards!(@planet.id)
          player.reload
        end.should change(player, type).by(@quest.rewards[reward])
      end
    end

    it "should reward units" do
      @qp.claim_rewards!(@planet.id)
      Unit::Trooper.count(:all, :conditions => {
          :level => 1, :player_id => @qp.player_id, 
            :location => @planet.location
      }).should == 2
      Unit::Shocker.count(:all, :conditions => {
          :level => 2, :player_id => @qp.player_id,
            :location => @planet.location
      }).should == 1
    end

    it "should fire created with units" do
      should_fire_event(
        [an_instance_of(Unit::Trooper), an_instance_of(Unit::Trooper),
          an_instance_of(Unit::Shocker)],
        EventBroker::CREATED,
        EventBroker::REASON_REWARD_CLAIMED
      ) do
        @qp.claim_rewards!(@planet.id)
      end
    end

    it "should reward experienced units" do
      @qp.claim_rewards!(@planet.id)
      units = Unit::Shocker.find(:all, :conditions => {
          :level => 2, :player_id => @qp.player_id,
            :location => @planet.location
      }).map(&:hp).uniq.should == [Unit::Shocker.hit_points(2)]
    end
  end

  describe "notifier" do
    before(:each) do
      @build = lambda { Factory.create(:quest_progress) }
      @after_build = lambda do |model|
        Factory.create(:objective, :quest => model.quest)
        Factory.create(:objective, :quest => model.quest)
      end
      @change = lambda { |model| model.completed += 1 }
    end

    @should_not_notify_create = true
    @should_not_notify_destroy = true
    it_should_behave_like "notifier"
  end
end