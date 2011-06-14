require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Objective::BecomeVip do
  describe "#initial_completed" do
    before(:each) do
      @objective = Factory.build(:o_become_vip, :level => 2, :count => 2)
    end
    
    it "should return 1 if player satisfies vip" do
      player = Factory.create(:player, :vip_level => 2)
      @objective.initial_completed(player.id).should == 1
    end
    
    it "should return 1 if player has greater vip level" do
      player = Factory.create(:player, :vip_level => 3)
      @objective.initial_completed(player.id).should == 1
    end
    
    it "should return 0 if player does not have required vip" do
      player = Factory.create(:player, :vip_level => 1)
      @objective.initial_completed(player.id).should == 0
    end
  end
  
  describe ".progress" do
    before(:each) do
      @player = Factory.create(:player, :vip_level => 2)
      @objective = Factory.create(:o_become_vip, :level => 2, :count => 2)
      @op = Factory.create(:objective_progress, :player => @player,
        :objective => @objective)
      @other_player_opts = {:vip_level => 2}
      @klass = @objective.class
    end

    it_should_behave_like "player objective"

    it "should progress if vip level is greater" do
      @player.vip_level += 1
      @player.save!

      lambda do
        Objective::BecomeVip.progress(@player)
        @op.reload
      end.should change(@op, :completed).by(1)
    end

    it "should not progress if vip level is too small" do
      @player.vip_level -= 1
      @player.save!

      lambda do
        Objective::BecomeVip.progress(@player)
        @op.reload
      end.should_not change(@op, :completed)
    end
  end
end