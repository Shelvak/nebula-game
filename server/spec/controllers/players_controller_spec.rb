require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe PlayersController do
  include ControllerSpecHelper

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