require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe QuestEventHandler do
  it "should register to EventBroker" do
    EventBroker.should_receive(:register).with(
      an_instance_of(QuestEventHandler))
    QuestEventHandler.new
  end

  describe ".filter" do
    it "should keep instance variables" do
      obj = CombatArray.new([], :x)
      filtered_obj = QuestEventHandler.filter(obj)
      filtered_obj.killed_by.should == obj.killed_by
    end

    it "should filter ObjectiveProgress" do
      QuestEventHandler.filter([ObjectiveProgress.new]).should be_blank
    end

    it "should filter QuestProgress" do
      QuestEventHandler.filter([QuestProgress.new]).should be_blank
    end

    it "should filter Event::MovementPrepare" do
      QuestEventHandler.filter(
        [Event::MovementPrepare.new(:route, :ids)]
      ).should be_blank
    end
  end

  describe "events" do
    before(:all) do
      @handler = QuestEventHandler.new

      # Don't get other events, only ones we submit
      EventBroker.unregister(@handler)
    end

    [
      [EventBroker::REASON_UPGRADE_FINISHED, "upgrade finished"]
    ].each do |reason, title|
      it "should update UpgradeTo objectives on #{title}" do
        models = [Factory.create(:building)]
        models[0].level += 1

        Objective::UpgradeTo.should_receive(:progress).with(
          models
        ).at_least(1).and_return(true)
        @handler.fire(models, EventBroker::CHANGED, reason)
      end

      it "should update HaveUpgradedTo objectives on #{title}" do
        models = [Factory.create(:building)]
        models[0].level += 1

        Objective::HaveUpgradedTo.should_receive(
          :progress
        ).with(models).and_return(true)
        @handler.fire(models, EventBroker::CHANGED, reason)
      end
    end

    describe "when level has not changed" do
      before(:each) do
        @models = [Factory.create(:building)]
      end

      it "should not update UpgradeTo objectives on combat finished" do
        Objective::UpgradeTo.should_not_receive(:progress)
        @handler.fire(@models, EventBroker::CHANGED,
          EventBroker::REASON_COMBAT)
      end

      it "should not update HaveUpgradedTo objectives on combat finished" do
        Objective::HaveUpgradedTo.should_not_receive(:progress)
        @handler.fire(@models, EventBroker::CHANGED,
          EventBroker::REASON_COMBAT)
      end
    end

    it "should update Destroy objectives on destroyed" do
      models = CombatArray.new([Factory.create(:building)], {})

      Objective::Destroy.should_receive(
        :progress
      ).with(models).and_return(true)
      @handler.fire(models, EventBroker::DESTROYED, nil)
    end

    it "should update both Destroy objectives if several types has " +
    "been destroyed" do
      quest = Factory.create(:quest)
      obj1 = Factory.create(:o_destroy, :key => "Unit::Gnat", :count => 2,
        :quest => quest)
      obj2 = Factory.create(:o_destroy, :key => "Unit::Glancer", :count => 2,
        :quest => quest)
      player = Factory.create(:player)
      op1 = Factory.create(:objective_progress, :objective => obj1,
        :player => player)
      op2 = Factory.create(:objective_progress, :objective => obj2,
        :player => player)

      gnat = Factory.create(:u_gnat)
      glancer = Factory.create(:u_glancer)
      models = CombatArray.new([gnat, glancer],
        {gnat => player.id, glancer => player.id})

      @handler.fire(models, EventBroker::DESTROYED, nil)
      op1.reload
      op2.reload
      [op1.completed, op2.completed].should == [1, 1]
    end

    it "should not update Destroy objectives if it's a simple array" do
      models = [Factory.create(:building)]

      Objective::Destroy.should_not_receive(
        :progress
      ).with(models).and_return(true)
      @handler.fire(models, EventBroker::DESTROYED, nil)
    end

    it "should regress HaveUpgradedTo upon destruction" do
      models = [Factory.create(:building)]

      Objective::HaveUpgradedTo.should_receive(
        :regress
      ).with(models, strict: false).and_return(true)
      @handler.fire(models, EventBroker::DESTROYED, nil)
    end
  end
end