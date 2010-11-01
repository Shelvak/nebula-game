require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe LoginController do
  include ControllerSpecHelper

  before(:each) do
    init_controller LoginController
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
      [
        GameController::ACTION_CONFIG,
        PlayersController::ACTION_SHOW,
        PlanetsController::ACTION_PLAYER_INDEX,
        TechnologiesController::ACTION_INDEX,
        QuestsController::ACTION_INDEX,
        NotificationsController::ACTION_INDEX,
        RoutesController::ACTION_INDEX,
      ].each do |action|
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