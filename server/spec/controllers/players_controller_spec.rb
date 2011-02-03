require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

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
        quests|index notifications|index routes|index}.each do |action|
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

    describe "players|logout" do
      before(:each) do
        @action = "players|logout"
        @params = {}
      end

      it "should allow players to logout" do
        @controller.should_receive(:disconnect)
        invoke @action, @params
      end

      it "should disconnect if player is unauthorized" do
        @controller.should_receive(:disconnect)
        invoke 'galaxies|index'
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
        should_respond_with :player => player
        push @action, @params
      end
    end

    describe "players|ratings" do
      before(:each) do
        @action = "players|ratings"
        @params = {}
      end

      it "should return ratings" do
        ratings = Player.where(:galaxy_id => player.galaxy_id).map do |player|
          player.as_json(:mode => :ratings)
        end
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
  end
end