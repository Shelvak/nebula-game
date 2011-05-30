require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Objective::DestroyNpcBuilding do
  describe ".progress" do
    it "should progress if npc building is destroyed" do
      objective = Factory.create(:o_destroy_npc_building,
        :key => "Building::NpcMetalExtractor", :count => 2)
      op = Factory.create(:objective_progress, :objective => objective)

      building = Factory.create(:b_npc_metal_extractor)
      objective.class.progress(building, op.player)
      lambda do
        op.reload
      end.should change(op, :completed).by(1)
    end
  end
end