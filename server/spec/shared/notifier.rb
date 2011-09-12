shared_examples_for "notifier" do |options|
  options.reverse_merge! :notify_on_create => true, :notify_on_update => true,
    :notify_on_destroy => true

  def create_model(options)
    model ||= options[:model] || options[:build].call.tap(&:save!)
    options[:after_build].call(model) if options[:after_build]
    model
  end

  if options[:notify_on_create]
    it "should notify on create" do
      model = options[:build].call
      should_fire_event(model, EventBroker::CREATED) do
        model.save!
      end
    end
  else
    it "should not notify on create if it's not wanted" do
      model = options[:build].call
      should_not_fire_event(@model, EventBroker::CREATED) do
        model.save!
      end
    end
  end
  
  if options[:notify_on_update]
    it "should notify on update" do
      model = create_model(options)
      should_fire_event(model, EventBroker::CHANGED,
          EventBroker::REASON_UPDATED) do
        options[:change].call(model)
        model.save!
      end
    end
  else
    it "should not notify on update if it's not wanted" do\
      model = create_model(options)
      should_not_fire_event(model, EventBroker::CHANGED,
          EventBroker::REASON_UPDATED) do
        options[:change].call(model)
        model.save!
      end
    end
  end

  if options[:notify_on_destroy]
    it "should notify on destroy" do
      model = create_model(options)
      should_fire_event(model, EventBroker::DESTROYED) do
        model.destroy
      end
    end
  else
    it "should not notify on destroy if it's not wanted" do
      model = create_model(options)
      should_not_fire_event(model, EventBroker::DESTROYED) do
        model.destroy
      end
    end
  end
end