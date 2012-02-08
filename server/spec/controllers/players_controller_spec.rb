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
        @params = {'server_player_id' => @test_player.id, 'web_player_id' => 3,
          'version' => Cfg.required_client_version}
      end

      it_behaves_like "with param options", %w{server_player_id web_player_id version}

      describe "client too old" do
        before(:each) do
          ClientVersion.should_receive(:ok?).with(@params['version']).
            and_return(false)
        end

        it "should respond with failure" do
          invoke @action, @params
          response_should_include(
            :success => false
          )
        end

        it "should respond with required client version" do
          invoke @action, @params
          response_should_include(
            :required_version => Cfg.required_client_version
          )
        end
        
        it "should disconnect on invalid login" do
          @controller.should_receive(:disconnect)
          invoke @action, @params
        end
      end

      describe "successfully authorized by web" do
        before(:each) do
          ControlManager.instance.stub(:login_authorized?).with(
            @test_player, @params['web_player_id']
          ).and_return(true)
        end

        it "should allow players to login to dev galaxy" do
          @test_player.galaxy.ruleset = 'dev'
          @test_player.galaxy.save!
          
          ControlManager.instance.should_not_receive(:login_authorized?)
          invoke @action, @params
          response_should_include :success => true
        end

        it "should allow players to login" do
          invoke @action, @params
          response_should_include :success => true
        end

        describe "reattachment" do
          before(:each) do
            Player.stub(:find).with(@params['server_player_id']).
              and_return(@test_player)
          end

          it "should not attach player if he is not detached" do
            @test_player.should_receive(:detached?).and_return(false)
            @test_player.should_not_receive(:attach!)
            invoke @action, @params
          end

          it "should attach player if he was detached" do
            @test_player.should_receive(:detached?).and_return(true)
            @test_player.should_receive(:attach!)
            invoke @action, @params
          end
        end

        it "should push actions" do
          invoke @action, @params

          [
            "game|config", "players|show", "planets|player_index",
            "technologies|index", "quests|index", "notifications|index",
            RoutesController::ACTION_INDEX,
            ChatController::ACTION_INDEX,
            PlayerOptionsController::ACTION_SHOW,
            GalaxiesController::ACTION_SHOW
          ].each_with_index do |action, index|
            message = {'action' => action, 'params' => {}}
            @dispatcher.pushed_messages[@test_player.id][index].should ==
              message
          end
        end

        it "should push announcement if it is set" do
          ends_at = 5.minutes.from_now
          message = "Hello!"
          AnnouncementsController.should_receive(:get).
            and_return([ends_at, message])
          invoke @action, @params

          @dispatcher.pushed_messages[@test_player.id].should include(
            {'action' => AnnouncementsController::ACTION_NEW,
              'params' => {'ends_at' => ends_at, 'message' => message}}
          )
        end

        it "should not push announcement if it is not set" do
          AnnouncementsController.should_receive(:get).
            and_return([nil, nil])
          invoke @action, @params

          @dispatcher.pushed_messages[@test_player.id].find do |message|
            message['action'] == AnnouncementsController::ACTION_NEW
          end.should be_nil
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
      end

      describe "not authorized by web" do
        before(:each) do
          ControlManager.instance.stub(:login_authorized?).with(
            @test_player, @params['web_player_id']
          ).and_return(false)
        end

        it "should return success => false" do
          should_respond_with :success => false
          invoke @action, @params
        end

        it "should disconnect on invalid login" do
          @controller.should_receive(:disconnect)
          invoke @action, @params
        end
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

      it_behaves_like "only push"

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

      it_behaves_like "with param options", %w{id}

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
        @player.portal_without_allies = true
        @player.save!

        @params = {'first_time' => false, 'portal_without_allies' => false}
      end

      it "should change first_time" do
        lambda do
          invoke @action, @params
          @player.reload
        end.should change(@player, :first_time).from(true).to(false)
      end

      it "should change portal_without_allies" do
        lambda do
          invoke @action, @params
          @player.reload
        end.should change(@player, :portal_without_allies).from(true).to(false)
      end
    end

    describe "players|vip" do
      before(:each) do
        player.creds = CONFIG['creds.vip'][0][0]

        @action = "players|vip"
        @params = {'vip_level' => 1}
      end

      it_behaves_like "with param options", %w{vip_level}

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

      it_behaves_like "with param options", %w{changes}
      it_behaves_like "only push"
      
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
      
      it_behaves_like "with param options", %w{amount}
      
      it "should call player#vip_convert" do
        player.should_receive(:vip_convert).with(@params['amount'])
        invoke @action, @params
      end
      
      it "should save player" do
        invoke @action, @params
        player.should be_saved
      end
    end

    describe "players|battle_vps_multiplier" do
      before(:each) do
        @target_id = 123

        @action = "players|battle_vps_multiplier"
        @params = {'target_id' => @target_id}
      end

      it_should_behave_like "with param options", %w{target_id}

      it "should return battle vps multiplier" do
        multiplier = 1.2
        Player.should_receive(:battle_vps_multiplier).
          with(player.id, @target_id).and_return(multiplier)
        invoke @action, @params
        response_should_include(:multiplier => multiplier)
      end
    end
  end
end
