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
        %w{game|config players|show planets|player_index technologies|index
        quests|index notifications|index routes|index
        chat|index}.each do |action|
          @dispatcher.should_receive(:push).with({
            'action' => action,
            'params' => {}
          }, @test_player.id).ordered
        end

        invoke @action, @params
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
  end
end