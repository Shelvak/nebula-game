shared_examples_for "player objective" do
  it "should not progress for other player" do
    player = Factory.create(:player, @other_player_params || {})
    lambda do
      @objective.class.progress(player)
      @op.reload
    end.should_not change(@op, :completed)
  end

  it "should progress for this player" do
    lambda do
      @objective.class.progress(@player)
      @op.reload
    end.should change(@op, :completed).by(1)
  end
end