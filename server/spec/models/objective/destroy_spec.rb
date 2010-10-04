require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Objective::Destroy do
  describe ".progress" do
    before(:each) do
      @objective = Factory.create :o_destroy, :key => "Unit::TestUnit",
        :count => 5
      @killer = Factory.create(:player)
      @unit = Factory.create(:unit)
      @models = CombatArray.new([@unit], {@unit => @killer.id})
    end

    it "should update objective progress for killer" do
      objective_progress = Factory.create :objective_progress,
        :objective => @objective, :player => @killer

      lambda do
        @objective.class.progress(@models)
        objective_progress.reload
      end.should change(objective_progress, :completed).by(1)
    end
  end
end