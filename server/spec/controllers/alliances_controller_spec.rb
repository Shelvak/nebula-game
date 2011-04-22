require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe AlliancesController do
  include ControllerSpecHelper

  before(:each) do
    init_controller AlliancesController, :login => true
  end

  describe "alliances|new" do
    before(:each) do
      @action = "alliances|new"
      @params = {'name' => "Mighty Wabbits"}

      @tech = Factory.create!(:t_alliances, :player => player, :level => 1)
    end

    @required_params = %w{name}
    it_should_behave_like "with param options"

    it "should fail if player does not have level 1 technology" do
      @tech.level = 0
      @tech.save!

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail if player is already in alliance" do
      player.alliance = Factory.create(:alliance)
      player.save!

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail if player has unexpired alliance cooldown" do
      player.alliance_cooldown_ends_at = 10.minutes.from_now
      player.save!

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should create alliance with name" do
      invoke @action, @params
      player.reload
      player.alliance.name.should == @params['name']
    end
    
    it "should set galaxy" do
      invoke @action, @params
      player.reload
      player.alliance.galaxy_id.should == player.galaxy_id
    end

    it "should set owner" do
      invoke @action, @params
      player.reload
      player.alliance.owner_id.should == player.id
    end

    it "should respond with alliance id otherwise" do
      invoke @action, @params
      player.reload
      response_should_include(:id => player.alliance_id)
    end
  end

  describe "alliances|invite" do
    before(:each) do
      @tech = Factory.create(:t_alliances, :player => player, :level => 1)
      @alliance = Factory.create(:alliance, :owner => player,
        :galaxy => player.galaxy)
      player.alliance = @alliance
      player.save!
      @invitee = Factory.create(:player, :galaxy => player.galaxy)
      @ss = Factory.create(:solar_system, :galaxy => player.galaxy)
      @planet = Factory.create(:planet, :player => @invitee,
        :solar_system => @ss)
      @fse = Factory.create(:fse_player, :player => player,
        :solar_system => @ss)

      @action = "alliances|invite"
      @params = {'planet_id' => @planet.id}
    end

    @required_params = %w{planet_id}
    it_should_behave_like "with param options"

    it "should fail if player does not see that planet" do
      @fse.destroy

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail if it is a battleground planet" do
      bg = Factory.create(:battleground, :galaxy => player.galaxy)
      bg_planet = Factory.create(:planet, :solar_system => bg,
        :player => @invitee)

      wh = Factory.create(:wormhole, :galaxy => bg.galaxy)
      Factory.create(:fse_player, :player => player, :solar_system => wh)

      lambda do
        invoke @action, @params.merge('planet_id' => bg_planet.id)
      end.should raise_error(GameLogicError)
    end

    it "should fail if alliance have reached max players" do
      @alliance.stub!(:full?).and_return(true)

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail if player does not own an alliance" do
      @alliance.owner = Factory.create(:player)
      @alliance.save!

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail if player is not even in alliance" do
      @alliance.destroy
      player.reload

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should create an invitation for invited player" do
      Notification.should_receive(:create_for_alliance_invite).with(
        @alliance, @invitee)
      invoke @action, @params
    end
  end

  describe "alliances|join" do
    before(:each) do
      @alliance = Factory.create(:alliance)
      @notification = Notification.create_for_alliance_invite(@alliance,
        player)

      @action = "alliances|join"
      @params = {'notification_id' => @notification}
    end

    it "should fail if notification belongs to other player" do
      @notification.player = Factory.create(:player)
      @notification.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if there is no such notification" do
      @notification.destroy

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if cooldown hasn't expired yet" do
      player.alliance_cooldown_ends_at = 10.minutes.from_now
      player.save!

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should respond with error if alliance if full" do
      Alliance.stub!(:find).with(@alliance.id).and_return(@alliance)
      @alliance.stub!(:full?).and_return(true)

      invoke @action, @params
      response_should_include(:success => false)
    end

    it "should respond with success if joined" do
      invoke @action, @params
      response_should_include(:success => true)
    end

    it "should invoke Alliance#accept" do
      Alliance.stub!(:find).with(@alliance.id).and_return(@alliance)
      @alliance.should_receive(:accept).with(player)
      invoke @action, @params
    end

    it "should destroy notification" do
      invoke @action, @params
      Notification.exists?(@notification).should be_false
    end

    it "should dispatch destroyed notification" do
      should_fire_event(@notification, EventBroker::DESTROYED) do
        invoke @action, @params
      end
    end
  end
end