require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Objective::HealHp do
  describe ".progress" do
    it "should progress by given hp" do
      objective = Factory.create(:o_heal_hp, :count => 100000)
      op = Factory.create(:objective_progress, :objective => objective)

      lambda do
        Objective::HealHp.progress(op.player, 5000)
        op.reload
      end.should change(op, :completed).by(5000)
    end
  end
end