require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Objective::HavePoints do
  describe "#initial_completed" do
    it "should return 0 if player does not have enough points" do
      player = Factory.create(:player, :economy_points => 3000)
      objective = Factory.create(:o_have_points, :limit => 5000)
      objective.initial_completed(player.id).should == 0
    end

    it "should return 1 if player does has enough points" do
      player = Factory.create(:player, :economy_points => 3000)
      objective = Factory.create(:o_have_points, :limit => 3000)
      objective.initial_completed(player.id).should == 1
    end
  end

  describe ".progress" do
    before(:each) do
      @limit = 1000
      @objective = Factory.create(:o_have_points, :limit => @limit,
        :count => 2)
      @op = Factory.create(:objective_progress, :objective => @objective)
      @player = @op.player
    end

    it "should progress if player has enough points" do
      @player.economy_points = @limit
      @objective.class.progress(@player)
      lambda do
        @op.reload
      end.should change(@op, :completed).by(1)
    end

    it "should not progress if player does not have enough points" do
      @player.economy_points = @limit - 1
      @objective.class.progress(@player)
      lambda do
        @op.reload
      end.should_not change(@op, :completed)
    end
  end
end