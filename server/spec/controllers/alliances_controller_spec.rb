require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

shared_examples_for "only by owner" do
  it "should fail if invoked not by alliance owner" do
    @alliance.owner = Factory.create(:player)
    @alliance.save!

    lambda do
      invoke @action, @params
    end.should raise_error(GameLogicError)
  end
end

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

    it_behaves_like "with param options", %w{name}

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

    it "should check for player alliance cooldown (global check)" do
      player.should_receive(:alliance_cooldown_expired?).with(nil)

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

    it "should call #accept on alliance with owner" do
      alliance = Factory.build(:alliance, :owner => player)
      Alliance.should_receive(:new).and_return(alliance)
      alliance.should_receive(:accept).with(player)
      invoke @action, @params
    end

    it "should respond with alliance id otherwise" do
      invoke @action, @params
      player.reload
      response_should_include(:id => player.alliance_id)
    end
    
    it "should respond with 0 if alliance name is not unique" do
      Factory.create(:alliance, :name => @params['name'], 
        :galaxy => player.galaxy)
      invoke @action, @params
      response_should_include(:id => 0)
    end
  end

  describe "alliances|invite" do
    before(:each) do
      @tech = Factory.create!(:t_alliances, :player => player, :level => 1)
      @alliance = Factory.create(:alliance, :owner => player,
        :galaxy => player.galaxy)
      player.alliance = @alliance
      player.save!
      @invitee = Factory.create(:player, :galaxy => player.galaxy)
      Alliance.stub(:visible_enemy_player_ids).with(@alliance.id).
        and_return([@invitee.id])

      @action = "alliances|invite"
      @params = {'player_id' => @invitee.id}
    end

    it_behaves_like "with param options", %w{player_id}
    it_behaves_like "only by owner"

    it "should fail if player does not see that planet" do
      Alliance.stub(:visible_enemy_player_ids).with(@alliance.id).
        and_return([])

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail if alliance have reached max players" do
      @alliance.stub!(:full?).and_return(true)

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

    it_behaves_like "with param options", %w{notification_id}

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

    it "should check if player alliance cooldown has expired (alliance wise)" do
      player.should_receive(:alliance_cooldown_expired?).with(@alliance.id)

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
    
    it "should create alliance joined notification" do
      Notification.should_receive(:create_for_alliance_joined).
        with(@alliance, player)
      invoke @action, @params
    end
  end

  describe "alliances|leave" do
    before(:each) do
      @alliance = Factory.create(:alliance)
      player.alliance = @alliance
      player.save!

      @action = "alliances|leave"
      @params = {}
    end

    it "should call #leave_alliance! on player" do
      player.should_receive(:leave_alliance!)
      invoke @action, @params
    end

    it "should work" do
      invoke @action, @params
    end
  end

  describe "alliances|kick" do
    before(:each) do
      @alliance = Factory.create(:alliance, :owner => player)
      player.alliance = @alliance
      player.save!
      @member = Factory.create(:player, :alliance => @alliance)

      @action = "alliances|kick"
      @params = {'player_id' => @member.id}
    end

    it_behaves_like "with param options", %w{player_id}
    it_behaves_like "only by owner"

    it "should fail if current player is not in alliance" do
      player.alliance = nil
      player.save!

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail if that player is not in this alliance" do
      @member.alliance = nil
      @member.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if invoked upon yourself" do
      lambda do
        invoke @action, @params.merge('player_id' => player.id)
      end.should raise_error(GameLogicError)
    end

    it "should kick player" do
      player.alliance.should_receive(:kick).with(@member)
      invoke @action, @params
    end

    it "should work properly" do
      invoke @action, @params
    end
  end

  describe "alliances|show" do
    before(:each) do
      @alliance = Factory.create(:alliance)
      @players = (1..10).map do
        Factory.create(:player_for_ratings, :alliance => @alliance)
      end

      @action = "alliances|show"
      @params = {'id' => @alliance.id}
    end

    it_behaves_like "with param options", %w{id}

    it "should respond with alliance name" do
      invoke @action, @params
      response_should_include(:name => @alliance.name)
    end

    it "should respond with alliance description" do
      invoke @action, @params
      response_should_include(:description => @alliance.description)
    end

    it "should respond with owner id" do
      invoke @action, @params
      response_should_include(:owner_id => @alliance.owner_id)
    end

    it "should include player ratings" do
      Alliance.stub!(:find).with(@alliance.id).and_return(@alliance)
      @alliance.stub!(:player_ratings).and_return(:ratings)
      invoke @action, @params
      response_should_include(:players => @alliance.player_ratings)
    end

    describe "when owner" do
      before(:each) do
        @alliance.owner = player
        @alliance.save!
      end

      it "should include invitable players" do
        Alliance.stub!(:find).with(@alliance.id).and_return(@alliance)
        @alliance.stub!(:invitable_ratings).and_return(:ratings)
        invoke @action, @params
        response_should_include(
          :invitable_players => @alliance.invitable_ratings
        )
      end
    end

    describe "when not owner" do
      it "should not include invitable players" do
        invoke @action, @params
        response[:invitable_players].should be_nil
      end
    end
  end

  describe "alliances|edit" do
    before(:each) do
      @alliance = Factory.create(:alliance, :owner => player)
      player.creds = CONFIG['creds.alliance.change']
      player.alliance = @alliance
      player.save!

      @action = "alliances|edit"
      @params = {'name' => "Foobar Heroes"}
    end

    it_behaves_like "only by owner"

    it "should reduce creds" do
      lambda do
        invoke @action, @params
        player.reload
      end.should change(player, :creds).to(0)
    end

    it "should fail if not enough creds" do
      player.creds -= 1
      player.save!

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should change alliance name" do
      invoke @action, @params
      @alliance.reload
      @alliance.name.should == @params['name']
    end

    it "should respond with error if alliance name is not unique" do
      other = Factory.create(:alliance, :galaxy => @alliance.galaxy)
      invoke @action, @params.merge("name" => other.name)
      response_should_include :error => 'not_unique'
    end

    it "should record cred stats" do
      should_record_cred_stats(:alliance_change, [player]) \
        { invoke @action, @params }
    end
  end

  describe "alliances|edit_description" do
    before(:each) do
      @alliance = Factory.create(:alliance, :owner => player)
      player.alliance = @alliance
      player.save!

      @action = "alliances|edit_description"
      @params = {'description' => 'lol'}
    end

    it_behaves_like "with param options", %w{description}

    it "should change alliance description" do
      invoke @action, @params
      @alliance.reload
      @alliance.description.should == @params['description']
    end
  end

  describe "alliances|ratings" do
    before(:each) do
      3.times do
        alliance = Factory.create(:alliance, :galaxy => player.galaxy)
        2.times do
          Factory.create(:player_for_ratings, :alliance => alliance,
            :galaxy => player.galaxy)
        end
      end

      @action = "alliances|ratings"
      @params = {}
    end

    it "should respond with ratings for this galaxy" do
      invoke @action, @params
      response_should_include(:ratings => Alliance.ratings(player.galaxy_id))
    end
  end

  describe "alliances|take_over" do
    before(:each) do
      @action = "alliances|take_over"
      @params = {}
      player.alliance = create_alliance
      player.alliance.stub!(:take_over!)
    end

    it "should fail if player is not in the alliance" do
      player.alliance = nil
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should call #take_over! on alliance" do
      player.alliance.should_receive(:take_over!).with(player)
      invoke @action, @params
    end

    it "should push alliances|show on success" do
      should_push(AlliancesController::ACTION_SHOW, 'id' => @player.alliance_id)
      invoke @action, @params
    end
  end

  describe "alliances|give_away" do
    before(:each) do
      @alliance = create_alliance :owner => player
      @member = Factory.create(:player, :alliance => @alliance)
      player.alliance.stub!(:transfer_ownership!)

      @action = "alliances|give_away"
      @params = {'player_id' => @member.id}
    end

    it_should_behave_like "with param options", %w{player_id}

    it "should fail if player is not in alliance" do
      player.alliance = nil
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail if player is not alliance owner" do
      @alliance.owner = Factory.create(:player, :alliance => @alliance)
      @alliance.save!
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail if new owner is not found" do
      @member.destroy
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should call #transfer_ownership! on alliance" do
      Player.stub!(:find).with(@member.id).and_return(@member)
      player.alliance.should_receive(:transfer_ownership!).with(@member)
      invoke @action, @params
    end

    it "should respond with success" do
      invoke @action, @params
      response_should_include(:status => "success")
    end

    it "should push alliances|show on success" do
      should_push(AlliancesController::ACTION_SHOW, 'id' => @alliance.id)
      invoke @action, @params
    end

    it "should respond with error if technology is too low" do
      player.alliance.stub(:transfer_ownership!).
        and_raise(Alliance::TechnologyLevelTooLow)
      invoke @action, @params
      response_should_include(:status => "technology_level_too_low")
    end
  end
end
