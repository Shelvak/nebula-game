require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe PlayersController do
  include ControllerSpecHelper

  describe "not logged in" do
    before(:each) do
      init_controller PlayersController
    end

    describe "players|login" do
      before(:each) do
        @controller.stub!(:disconnect)
        # This cannot be @player because it SOMEHOW manages to get into
        # LoginController scope...
        @test_player = Factory.create(:player)

        @action = "players|login"
        @params = {'galaxy_id' => @test_player.galaxy_id,
          'auth_token' => @test_player.auth_token}
      end

      @required_params = %w{galaxy_id auth_token}
      it_should_behave_like "with param options"

      it "should allow players to login" do
        should_respond_with :success => true
        invoke @action, @params
      end

      it "should push actions" do
        invoke @action, @params
        
        %w{game|config players|show planets|player_index technologies|index
        quests|index notifications|index routes|index
        chat|index}.each_with_index do |action, index|
          message = {'action' => action, 'params' => {}}
          @dispatcher.pushed_messages[@test_player.id][index].should == 
            message
        end
      end
      
      it "should push daily_bonus|show if there is a bonus available" do
        @test_player.daily_bonus_at = 1.day.ago
        @test_player.save!
        invoke @action, @params
        
        @dispatcher.pushed_messages[@test_player.id].should include(
          {'action' => DailyBonusController::ACTION_SHOW, 'params' => {}}
        )
      end
      
      it "should not push daily_bonus|show if there is no bonus" do
        @test_player.daily_bonus_at = 1.day.from_now
        @test_player.save!
        invoke @action, @params
        
        @dispatcher.pushed_messages[@test_player.id].should_not include(
          {'action' => DailyBonusController::ACTION_SHOW, 'params' => {}}
        )
      end

      it "should validate login data" do
        should_respond_with :success => false
        invoke @action, @params.merge('auth_token' => "ASDASD")
      end

      it "should disconnect on invalid login" do
        @controller.should_receive(:disconnect)
        invoke @action, @params.merge('auth_token' => "ASDASD")
      end
    end
  end

  describe "logged in" do
    before(:each) do
      init_controller PlayersController, :login => true
    end

    describe "players|show" do
      before(:each) do
        @action = "players|show"
        @params = {}
      end

      it_should_behave_like "only push"

      it "should respond with player" do
        should_respond_with :player => player.as_json
        push @action, @params
      end
    end

    describe "players|show_profile" do
      before(:each) do
        @action = "players|show_profile"
        @params = {'id' => player.id}
      end

      @required_params = %w{id}
      it_should_behave_like "with param options"

      it "should include player" do
        invoke @action, @params
        player_hash = Player.ratings(player.galaxy_id,
          Player.where(:id => player.id))[0]
        response_should_include(:player => player_hash)
      end

      it "should include achievements" do
        achievement = [{}]
        Quest.stub!(:achievements_by_player_id).
          with(player.id).and_return(achievement)
        invoke @action, @params
        response_should_include(:achievements => achievement)
      end
    end

    describe "players|ratings" do
      before(:each) do
        @action = "players|ratings"
        @params = {}
      end

      it "should return ratings" do
        ratings = Player.ratings(player.galaxy_id)
        invoke @action, @params
        response_should_include(:ratings => ratings)
      end
    end

    describe "players|edit" do
      before(:each) do
        @action = "players|edit"
        @player = self.player
        @player.first_time = true
        @player.save!

        @params = {'first_time' => false}
      end

      it "should change first_time" do
        lambda do
          invoke @action, @params
          @player.reload
        end.should change(@player, :first_time).from(true).to(false)
      end
    end

    describe "players|vip" do
      before(:each) do
        player.creds = CONFIG['creds.vip'][0][0]

        @action = "players|vip"
        @params = {'vip_level' => 1}
      end

      @required_params = %w{vip_level}
      it_should_behave_like "with param options"

      it "should invoke vip_start!" do
        player.should_receive(:vip_start!).with(@params['vip_level'])
        invoke @action, @params
      end

      it "should fail with game logic error if index is unknown" do
        lambda do
          invoke @action, @params.merge('vip_level' => 100)
        end.should raise_error(GameLogicError)
      end

      it "should work" do
        invoke @action, @params
      end
    end

    describe "players|status_change" do
      before(:each) do
        @action = "players|status_change"
        @params = {'changes' => :changes}
      end

      @required_params = %w{changes}
      it_should_behave_like "with param options"
      it_should_behave_like "only push"
      
      it "should respond" do
        should_respond_with :changes => @params['changes']
        push @action, @params
      end
    end
  
    describe "players|convert_creds" do
      before(:each) do
        @action = "players|convert_creds"
        @params = {'amount' => 1000}
        player.vip_level = 1
        player.vip_creds = @params['amount']
        player.creds = @params['amount'] + 100
      end
      
      @required_params = %w{amount}
      it_should_behave_like "with param options"
      
      it "should call player#vip_convert" do
        player.should_receive(:vip_convert).with(@params['amount'])
        invoke @action, @params
      end
      
      it "should save player" do
        invoke @action, @params
        player.should be_saved
      end
    end
  end
end
