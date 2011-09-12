shared_examples_for "with resetable cooldown" do
  describe "#start_cooldown!" do
    it "should reset cooldown if cooldown is nil" do
      @model.cooldown_ends_at = nil
      @model.should_receive(:reset_cooldown!)
      @model.start_cooldown!
    end
    
    it "should do nothing if cooldown is not nil" do
      @model.cooldown_ends_at = 10.minutes.from_now
      @model.should_not_receive(:reset_cooldown!)
      @model.start_cooldown!
    end
  end
  
  describe "#reset_cooldown!" do
    it "should work if we don't have a cooldown" do
      @model.reset_cooldown!
      @model.should have_callback(CallbackManager::EVENT_COOLDOWN_EXPIRED,
        @model.cooldowns_at)
    end

    it "should work if we already have a cooldown" do
      @model.reset_cooldown!
      @model.reset_cooldown!
      @model.should have_callback(CallbackManager::EVENT_COOLDOWN_EXPIRED,
        @model.cooldowns_at)
    end

    it "should dispatch changed on building" do
      should_fire_event(@model, EventBroker::CHANGED) do
        @model.reset_cooldown!
      end
    end
  end
end
