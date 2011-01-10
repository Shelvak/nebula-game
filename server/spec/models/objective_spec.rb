require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Objective do
  describe ".progress" do
    before(:each) do
      @objective = Factory.create :objective, :key => "Unit::TestUnit",
        :count => 5
      @models = [Factory.create(:unit)]
    end

    it "should update objective progress for owner" do
      objective_progress = Factory.create :objective_progress,
        :objective => @objective, :player => @models[0].player

      lambda do
        @objective.class.progress(@models)
        objective_progress.reload
      end.should change(objective_progress, :completed).by(1)
    end

    it "should update objective regress for owner" do
      objective_progress = Factory.create :objective_progress,
        :objective => @objective, :player => @models[0].player
      objective_progress.completed = 1
      objective_progress.save!

      lambda do
        @objective.class.regress(@models)
        objective_progress.reload
      end.should change(objective_progress, :completed).by(-1)
    end

    it "should not set completed < 0" do
      objective_progress = Factory.create :objective_progress,
        :objective => @objective, :player => @models[0].player,
        :completed => 0

      lambda do
        @objective.class.regress(@models)
        objective_progress.reload
      end.should_not change(objective_progress, :completed)
    end

    it "should not update if it doesn't meet level constraint" do
      @objective.level = 2
      @objective.save!
      objective_progress = Factory.create :objective_progress,
        :objective => @objective, :player => @models[0].player

      lambda do
        @objective.class.progress(@models)
        objective_progress.reload
      end.should_not change(objective_progress, :completed)
    end

    it "should update multiple objective progresses if model classes " +
    "are mixed" do
      player = @models[0].player
      @models.push Factory.create(:u_trooper, :player => player)
      objective2 = Factory.create(:objective, :key => "Unit::Trooper",
        :count => 5)
      objective_progress1 = Factory.create :objective_progress,
        :objective => @objective, :player => player
      objective_progress2 = Factory.create :objective_progress,
        :objective => objective2, :player => player

      @objective.class.progress(@models)
      [objective_progress1, objective_progress2].each do |op|
        op.reload
        op.completed.should == 1
      end
    end

    it "should not progress for enemies" do
      player1 = @models[0].player
      player2 = Factory.create(:player)

      objective_progress1 = Factory.create :objective_progress,
        :objective => @objective, :player => player1
      objective_progress2 = Factory.create :objective_progress,
        :objective => @objective, :player => player2

      @objective.class.progress(@models)
      objective_progress1.reload
      objective_progress2.reload
      objective_progress1.completed.should == 1
      objective_progress2.completed.should == 0
    end

    describe "alliance" do
      before(:each) do
        @objective.alliance = true
        @objective.save!

        alliance = Factory.create :alliance

        player = @models[0].player
        player.alliance = alliance
        player.save!
        ally = Factory.create :player, :alliance => alliance

        @objective_progress = Factory.create :objective_progress,
          :objective => @objective, :player => ally
      end

      it "should update objective progresses for alliance members" do
        lambda do
          @objective.class.progress(@models)
          @objective_progress.reload
        end.should change(@objective_progress, :completed).by(1)
      end
    end

    it "should not update objective progress for other players" do
      objective_progress = Factory.create :objective_progress,
        :objective => @objective

      lambda do
        @objective.class.progress(@models)
        objective_progress.reload
      end.should_not change(objective_progress, :completed)
    end

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
  
    # This happens if:
    # 
    # You have 2 quests:
    # Q1: have 1 Trooper
    # Q2: have 2 Troopers
    # 
    # Q1 gets completed, Q2 gets it's #initial_completed set and THEN gets
    # progressed by .progress loop.
    #
    it "should not progress newly started objectives" do
      player = @models[0].player

      quest1 = @objective.quest
      quest2 = Factory.create(:quest, :parent => quest1)
      objective2 = Factory.create :objective, :key => "Unit::TestUnit",
        :count => 6, :quest => quest2
      op1 = Factory.create(:objective_progress, :player => player,
        :objective => @objective)
      qp1 = Factory.create(:quest_progress, :player => player,
        :quest => quest1)

      @objective.class.progress(@models * @objective.count)
      lambda do
        op1.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
      op2 = ObjectiveProgress.where(
        :player_id => player.id, :objective_id => objective2.id).first
      op2.completed.should == 0
    end
  end
end