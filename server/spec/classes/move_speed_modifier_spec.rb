require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe MoveSpeedModifier do
  describe ".new" do
    it "should fail if speed modifier is more than max" do
      lambda do
        MoveSpeedModifier.new(CONFIG['units.move.modifier.max'] + 0.01)
      end.should raise_error(GameLogicError)
    end

    it "should fail if speed modifier is less than min" do
      lambda do
        MoveSpeedModifier.new(CONFIG['units.move.modifier.min'] - 0.01)
      end.should raise_error(GameLogicError)
    end
  end

  describe "#deduct_creds!" do
    before(:each) do
      @modifier = MoveSpeedModifier.new(CONFIG['units.move.modifier.min'])
      @hop_count = 3
      @modifier.stub!(:hop_count).and_return(@hop_count)
      @creds_needed = Cfg.units_speed_up(@modifier.to_f, @hop_count)
      @player = Factory.create(:player, :creds => @creds_needed)
    end

    it "should fail if player does not have enough credits" do
      @player.creds -= 1
      @player.save!

      lambda do
        @modifier.deduct_creds!(@player, [], :source, :target, false)
      end.should raise_error(GameLogicError)
    end

    it "should reduce creds from player" do
      lambda do
        @modifier.deduct_creds!(@player, [], :source, :target, false)
        @player.reload
      end.should change(@player, :creds).to(0)
    end
    
    it "should not reduce more than max" do
      @player.creds = CONFIG['creds.move.speed_up.max_cost']
      @player.save!
      @modifier.stub!(:hop_count).and_return(10000)
      
      lambda do
        @modifier.deduct_creds!(@player, [], :source, :target, false)
        @player.reload
      end.should change(@player, :creds).to(0)
    end

    it "should record cred stats" do
      CredStats.should_receive(:movement_speed_up!).with(@player,
        @creds_needed)
      @modifier.deduct_creds!(@player, [], :source, :target, false)
    end

    it "should progress achievement" do
      Objective::AccelerateFlight.should_receive(:progress).with(@player)
      @modifier.deduct_creds!(@player, [], :source, :target, false)
    end
  end
end