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
  end
end