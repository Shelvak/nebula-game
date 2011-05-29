require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe DailyBonusController do
  include ControllerSpecHelper

  before(:each) do
    init_controller DailyBonusController, :login => true
  end
  
  describe "daily_bonus|get" do
    before(:each) do
      @action = "daily_bonus|get"
      @params = {}
    end
    
    it "should fail if bonus is not available" do
      player.stub!(:daily_bonus_available?).and_return(false)
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end
    
    it "should return rewards" do
      DailyBonus.should_receive(:get_bonus).with(player.id, player.points).
        and_return(:bonus)
      invoke @action, @params
      response_should_include(:bonus => :bonus.as_json)
    end
  end
  
  describe "daily_bonus|claim" do
    before(:each) do
      @planet = Factory.create(:planet, :player => player)
      @action = "daily_bonus|claim"
      @params = {'planet_id' => @planet.id}
    end
    
    @required_params = %w{planet_id}
    it_should_behave_like "with param options"
    
    it "should fail if user does not own that planet" do
      @planet.player = nil
      @planet.save!
      
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
    
    it "should call #claim on Rewards object" do
      bonus = mock(Rewards)
      DailyBonus.should_receive(:get_bonus).with(player.id, player.points).
        and_return(bonus)
      bonus.should_receive(:claim!).with(@planet, player)
      invoke @action, @params
    end
    
    it "should save Player#daily_bonus_at" do
      invoke @action, @params
      player.reload
      player.daily_bonus_at.should be_close(
        CONFIG['daily_bonus.cooldown'].from_now,
        SPEC_TIME_PRECISION)
    end
  end
end