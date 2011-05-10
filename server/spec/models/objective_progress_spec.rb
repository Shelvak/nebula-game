require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe ObjectiveProgress do
  describe "object" do
    before(:all) do
      @class = ObjectiveProgress
    end

    it_should_behave_like "object"
  end

  it "should not allow setting completed < 0" do
    op = Factory.create :objective_progress
    op.completed = -2
    op.save!
    op.completed.should == 0
  end

  describe "when completed >= objective.count" do
    before(:each) do
      @quest = Factory.create(:quest)
      @qp = Factory.create(:quest_progress, :quest => @quest)
      @objective = Factory.create(:objective, :quest => @quest,
        :count => 2)
      @op = Factory.create(:objective_progress, :objective => @objective,
        :player => @qp.player)
    end

    it "should call on_complete even if completed > count" do
      @op.should_receive(:on_complete)
      @op.completed = @op.objective.count + 1
      @op.save!
    end

    it "should update QuestProgress#completed" do
      lambda do
        @op.completed = @op.objective.count
        @op.save!
        @qp.reload
      end.should change(@qp, :completed).by(1)
    end

    it "should destroy itself" do
      @op.completed = @op.objective.count
      @op.save!
      @op.should be_frozen
    end
  end

  describe "notification" do
    before(:each) do
      @build = lambda do
        quest = Factory.create(:quest)
        qp = Factory.create(:quest_progress, :quest => quest)
        objective = Factory.create(:objective, :quest => quest,
          :count => 2)
        Factory.build(:objective_progress, :objective => objective,
          :player => qp.player)
      end
      @change = lambda { |model| model.completed += 1 }
    end

    @should_not_notify_create = true
    it_should_behave_like "notifier"

    it "should not dispatch updated if it's going to be destroyed" do
      model = @build.call.tap(&:save!)
      should_not_fire_event(model, EventBroker::CHANGED,
          EventBroker::REASON_UPDATED) do
        model.completed = 2
        model.save!
      end
    end

    describe "for achievement" do
      before(:each) do
        @model = @build.call.tap(&:save!)
        quest = @model.objective.quest
        quest.achievement = true
        quest.save!
      end
    
      it "should not dispatch updated if it's for achievement" do
        should_not_fire_event(@model, EventBroker::CHANGED,
            EventBroker::REASON_UPDATED) do
          @change.call(@model)
          @model.save!
        end
      end

      it "should not dispatch destroyed" do
        should_not_fire_event(@model, EventBroker::DESTROYED) do
          @model.destroy
        end
      end
    end
  end
end