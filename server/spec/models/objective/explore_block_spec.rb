require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Objective::ExploreBlock do
  describe ".progress" do
    before(:each) do
      @player = Factory.create(:player)
      @planet = Factory.create(:planet, :exploration_x => 0,
        :exploration_y => 0, :player => @player)
      @tile = Factory.create(:t_folliage_4x3, :planet => @planet, :x => 0,
        :y => 0)

      @objective = Factory.create :o_explore_block, :count => 2,
        :limit => 12
      @op = Factory.create :objective_progress,
        :objective => @objective, :player => @player
    end

    it "should progress if area is sufficient" do
      lambda do
        Objective::ExploreBlock.progress(@planet)
        @op.reload
      end.should change(@op, :completed).by(1)
    end

    it "should progress if area is not limited" do
      @objective.limit = nil
      @objective.save!

      lambda do
        Objective::ExploreBlock.progress(@planet)
        @op.reload
      end.should change(@op, :completed).by(1)
    end

    it "should not progress if area is unsufficient" do
      @objective.limit += 1
      @objective.save!

      lambda do
        Objective::ExploreBlock.progress(@planet)
        @op.reload
      end.should_not change(@op, :completed)
    end

    it "should benefit the planet owner" do
      @planet.player = Factory.create(:player)
      @planet.save!

      lambda do
        Objective::ExploreBlock.progress(@planet)
        @op.reload
      end.should_not change(@op, :completed)
    end
  end
end