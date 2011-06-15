require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Objective::UpgradeTo do
  describe "have upgraded to level 2 bug (mantis #356)" do
    before(:each) do
      @player = Factory.create(:player)
      @objective = Factory.create(:o_upgrade_to,
        :key => "Building::TestBuilding", :level => 1, :count => 3)
      @qp = Factory.create(:quest_progress, :quest => @objective.quest,
        :player => @player)
      @op = Factory.create(:objective_progress, :objective => @objective,
        :player => @player)
      @planet = Factory.create(:planet, :player => @player)
      @building = Factory.create(:building_built, :planet => @planet,
        :level => 1)
    end

    it "should progress objective by 1 if we have level 2 building" do
      @objective.class.progress([@building])
      @building.level = 2
      @objective.class.progress([@building])
      @op.reload
      @op.completed.should == 1
    end

    it "should progress objective by 2 if we have 2 level 1 buildings" do
      @objective.class.progress([@building])
      @objective.class.progress([@building])
      @op.reload
      @op.completed.should == 2
    end
  end

  # This occurs if we have quest:
  # * Have 3 Seekers (of level 1).
  #
  # Let's say you have completed = 1 and you get Seeker of level 2.
  #
  # Quest should still be progressed, but with strict checking (==), it
  # fails. However if we turn it into lose check (>=), then #356 fails.
  #
  # So we need to be able to switch that behaviour.
  #
  describe "have 3 seekers bug" do
    it "should progress by 1 if we get a bigger level" do
      objective = Factory.create(:o_upgrade_to, :count => 3,
                                 :key => "Unit::Seeker")
      op = Factory.create(:objective_progress, :objective => objective)
      seeker = Factory.create!(:u_seeker, :player => op.player, :level => 2)
      lambda do
        objective.class.progress([seeker], false)
        op.reload
      end.should change(op, :completed).by(1)
    end
  end
end
