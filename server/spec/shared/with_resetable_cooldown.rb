describe "with resetable cooldown", :shared => true do
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