require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe QuestEventHandler do
  it "should register to EventBroker" do
    EventBroker.should_receive(:register).with(
      an_instance_of(QuestEventHandler))
    QuestEventHandler.new
  end

  describe "events" do
    before(:all) do
      @handler = QuestEventHandler.new

      # Don't get other events, only ones we submit
      EventBroker.unregister(@handler)
    end

    it "should update UpgradeTo objectives on upgrade finished" do
      models = [Factory.create(:building)]

      Objective::UpgradeTo.should_receive(:progress).with(
        models
      ).and_return(true)
      @handler.fire(models, EventBroker::CHANGED,
        EventBroker::REASON_UPGRADE_FINISHED)
    end

    it "should update HaveUpgradedTo objectives on upgrade finished" do
      models = [Factory.create(:building)]

      Objective::HaveUpgradedTo.should_receive(
        :progress
      ).with(models).and_return(true)
      @handler.fire(models, EventBroker::CHANGED,
        EventBroker::REASON_UPGRADE_FINISHED)
    end

    it "should update HaveUpgradedTo objectives on reward claimed" do
      models = [Factory.create(:unit)]

      Objective::HaveUpgradedTo.should_receive(
        :progress
      ).with(models).and_return(true)
      @handler.fire(models, EventBroker::CREATED,
        EventBroker::REASON_REWARD_CLAIMED)
    end

    it "should update Destroy objectives on destroyed" do
      models = CombatArray.new([Factory.create(:building)], {})

      Objective::Destroy.should_receive(
        :progress
      ).with(models).and_return(true)
      @handler.fire(models, EventBroker::DESTROYED, nil)
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
      ).with(models).and_return(true)
      @handler.fire(models, EventBroker::DESTROYED, nil)
    end

    it "should update AnnexPlanet objectives on planet owner changed" do
      models = [Factory.create(:planet)]

      Objective::AnnexPlanet.should_receive(
        :progress
      ).with(models).and_return(true)
      @handler.fire(models, EventBroker::CHANGED,
        EventBroker::REASON_OWNER_CHANGED)
    end

    it "should update HavePlanets objectives on planet owner changed" do
      models = [Factory.create(:planet)]

      Objective::HavePlanets.should_receive(
        :progress
      ).with(models).and_return(true)
      @handler.fire(models, EventBroker::CHANGED,
        EventBroker::REASON_OWNER_CHANGED)
    end
  end
end