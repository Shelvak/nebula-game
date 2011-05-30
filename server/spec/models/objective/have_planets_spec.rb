require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Objective::HavePlanets do
  describe "#initial_completed" do
    it "should count planets for single player" do
      obj = Factory.create(:o_have_planets)
      player = Factory.create(:player, :planets_count => 2)
      obj.initial_completed(player.id).should == 2
    end

    it "should count alliance planets too" do
      alliance = Factory.create(:alliance)
      player1 = Factory.create(:player, :alliance => alliance,
        :planets_count => 1)
      player2 = Factory.create(:player, :alliance => alliance,
        :planets_count => 1)

      obj = Factory.create(:o_have_planets, :alliance => true)
      obj.initial_completed(player1.id).should == 2
    end

    it "should not count other planets" do
      player1 = Factory.create(:player, :planets_count => 1)
      player2 = Factory.create(:player, :planets_count => 1)

      obj = Factory.create(:o_have_planets)
      obj.initial_completed(player1.id).should == 1
    end
  end

  describe ".progress" do
    before(:each) do
      @old = Factory.create(:player)
      @new = Factory.create(:player)
      @planet = Factory.create(:planet, :player => @old)
      # Change player
      @planet.player = @new
      @models = [@planet]

      @obj = Factory.create(:o_have_planets, :count => 3)
      @op_old = Factory.create(:objective_progress, :objective => @obj,
        :completed => 1, :player => @old)
      @op_new = Factory.create(:objective_progress, :objective => @obj,
        :completed => 1, :player => @new)
    end

    describe "BG planets" do
      before(:each) do
        bg = Factory.create(:battleground, :galaxy => @new.galaxy)
        @planet.solar_system = bg
        @planet.save!
      end

      it "should not reduce old owner progress" do
        lambda do
          @obj.class.progress(@models)
          @op_old.reload
        end.should_not change(@op_old, :completed).by(-1)
      end

      it "should not increase new owner progress" do
        lambda do
          @obj.class.progress(@models)
          @op_new.reload
        end.should_not change(@op_new, :completed).by(1)
      end
    end

    it "should reduce old owner progress by 1" do
      lambda do
        @obj.class.progress(@models)
        @op_old.reload
      end.should change(@op_old, :completed).by(-1)
    end

    it "should increase new owner progress by 1" do
      lambda do
        @obj.class.progress(@models)
        @op_new.reload
      end.should change(@op_new, :completed).by(1)
    end

    it "should not fail if old owner is nil" do
      @planet.player = nil
      @planet.save!
      @planet.player = @new
      lambda do
        @obj.class.progress(@models)
      end.should_not raise_error
    end

    it "should not fail if new owner is nil" do
      @planet.player = nil
      lambda do
        @obj.class.progress(@models)
      end.should_not raise_error
    end
  end
end