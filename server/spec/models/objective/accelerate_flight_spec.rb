require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Objective::AccelerateFlight do
  describe ".progress" do
    before(:each) do
      @player = Factory.create(:player)
      @objective = Factory.create(:o_accelerate_flight, :count => 2)
      @op = Factory.create(:objective_progress, :player => @player,
        :objective => @objective)
    end

    it_should_behave_like "player objective"
  end
end