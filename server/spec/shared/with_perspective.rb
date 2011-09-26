shared_examples_for "with :perspective" do |model, player, status|
  it "should include status if given player id" do
    model ||= @model
    player ||= @player
    status ||= @status
    model.as_json(:perspective => player)["status"].should == status
  end

  it "should include status if given resolver" do
    model ||= @model
    player ||= @player
    status ||= @status
    model.as_json(
      :perspective => StatusResolver.new(player)
    )["status"].should == status
  end
end