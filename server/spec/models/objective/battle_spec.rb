require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Objective::Battle do
  describe ".progress" do
    before(:each) do
      @player = Factory.create(:player)
      @objective = Factory.create(:o_battle, 
        :outcome => Combat::OUTCOME_WIN, :count => 5)
      @op = Factory.create(:objective_progress, :objective => @objective,
        :player => @player)
    end

    it "should not progress for wrong player" do
      lambda do
        @objective.class.progress({"0" => Combat::OUTCOME_WIN})
        @op.reload
      end.should_not change(@op, :completed)
    end

    it "should not progress if we need different outcome" do
      lambda do
        @objective.class.progress({@player.id.to_s => Combat::OUTCOME_LOSE})
        @op.reload
      end.should_not change(@op, :completed)
    end

    it "should progress" do
      lambda do
        @objective.class.progress({@player.id.to_s => Combat::OUTCOME_WIN})
        @op.reload
      end.should change(@op, :completed).by(1)
    end
  end
end