require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Objective::HavePoints do
  describe ".progress" do
    before(:each) do
      @limit = 1000
      @objective = Factory.create(:o_have_points, :limit => @limit,
        :count => 2)
      @op = Factory.create(:objective_progress, :objective => @objective)
      @player = @op.player
    end

    it "should progress if player has enough points" do
      @player.points = @limit
      @objective.class.progress(@player)
      lambda do
        @op.reload
      end.should change(@op, :completed).by(1)
    end

    it "should not progress if player does not have enough points" do
      @player.points = @limit - 1
      @objective.class.progress(@player)
      lambda do
        @op.reload
      end.should_not change(@op, :completed)
    end
  end
end