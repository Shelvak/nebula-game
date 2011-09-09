shared_examples_for "notifier" do
  if @should_not_notify_create
    it "should not notify on create if it's not wanted" do
      model = @build.call
      should_not_fire_event(@model, EventBroker::CREATED) do
        model.save!
      end
    end
  else
    it "should notify on create" do
      model = @build.call
      should_fire_event(model, EventBroker::CREATED) do
        model.save!
      end
    end
  end
  
  if @should_not_notify_update
    it "should not notify on update if it's not wanted" do
      @model ||= @build.call.tap(&:save!)
      @after_build.call(@model) if @after_build

      should_not_fire_event(@model, EventBroker::CHANGED,
          EventBroker::REASON_UPDATED) do
        @change.call(@model)
        @model.save!
      end
    end
  else
    it "should notify on update" do
      @model ||= @build.call.tap(&:save!)
      @after_build.call(@model) if @after_build

      should_fire_event(@model, EventBroker::CHANGED,
          EventBroker::REASON_UPDATED) do
        @change.call(@model)
        @model.save!
      end
    end
  end

  if @should_not_notify_destroy
    it "should not notify on destroy if it's not wanted" do
      @model ||= @build.call.tap(&:save!)
      @after_build.call(@model) if @after_build

      should_not_fire_event(@model, EventBroker::DESTROYED) do
        @model.destroy
      end unless Parts::Notifier.should_notify?(@model.class, :destroy)
    end
  else
    it "should notify on destroy" do
      @model ||= @build.call.tap(&:save!)
      @after_build.call(@model) if @after_build

      should_fire_event(@model, EventBroker::DESTROYED) do
        @model.destroy
      end if Parts::Notifier.should_notify?(@model.class, :destroy)
    end
  end
end