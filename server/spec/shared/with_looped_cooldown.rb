shared_examples_for "with looped cooldown" do
  it "should register new cooldown when cooldown hits" do
    @model.class.cooldown_expired_callback(@model)
    @model.should have_callback(
      CallbackManager::EVENT_COOLDOWN_EXPIRED, @model.cooldowns_at
    )
  end
end