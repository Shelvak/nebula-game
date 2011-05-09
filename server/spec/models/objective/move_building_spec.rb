require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Objective::MoveBuilding do
  describe ".progress" do
    it "should work" do
      objective = Factory.create(:o_move_building, :count => 5)
      op = Factory.create(:objective_progress, :objective => objective)
      planet = Factory.create(:planet, :player => op.player)
      building = Factory.create(:building, :planet => planet)

      lambda do
        objective.class.progress(building)
        op.reload
      end.should change(op, :completed).by(1)
    end
  end
end