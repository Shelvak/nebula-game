require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Objective::HaveUpgradedTo do
  describe "#initial_completed" do
    before(:each) do
      @player = Factory.create(:player)
    end

    [
      [
        "units",
        "Unit::TestUnit",
        lambda { |p| Factory.create :unit_built, :player => p }
      ],
      [
        "buildings",
        "Building::TestBuilding",
        lambda do |p|
          planet = Factory.create(:planet, :player => p)
          Factory.create(:building_built, :planet => planet)
        end
      ]
    ].each do |title, key, create|
      it "should calculate #{title} that satisfy conditions" do
        create.call(@player)
        objective = Factory.create :o_have_upgraded_to, :key => key
        objective.initial_completed(@player.id).should == 1
      end

      it "should calculate #{title} from alliance too" do
        alliance = Factory.create :alliance
        @player.alliance = alliance
        @player.save!

        ally = Factory.create :player, :alliance => alliance
        create.call(ally)
        
        objective = Factory.create :o_have_upgraded_to,
          :alliance => true, :key => key
        objective.initial_completed(@player.id).should == 1
      end

      it "should not calculate #{title} that are not of that player" do
        create.call(@player)
        player = Factory.create :player
        objective = Factory.create :o_have_upgraded_to, :key => key
        objective.initial_completed(player.id).should == 0
      end

      it "should not calculate #{title} that do not satisfy level" do
        create.call(@player)
        objective = Factory.create :o_have_upgraded_to, :level => 2,
          :key => key
        objective.initial_completed(@player.id).should == 0
      end
    end
  end

  describe "have upgraded to level 2 bug (mantis #356)" do
    before(:each) do
      @player = Factory.create(:player)
      @objective = Factory.create(:o_have_upgraded_to,
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
end