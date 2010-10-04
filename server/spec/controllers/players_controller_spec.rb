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
end