require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe RoutesController do
  include ControllerSpecHelper

  before(:each) do
    init_controller RoutesController, :login => true
  end

  describe "routes|index" do
    before(:each) do
      @action = "routes|index"
      @params = {}
      Factory.create(:route, :player => player)
    end

    it_should_behave_like "only push"

    it "should respond with player routes" do
      should_respond_with :routes => Route.find_all_by_player_id(player.id)
      push @action, @params
    end
  end

  describe "routes|destroy" do
    before(:each) do
      @action = "routes|destroy"
      @route = Factory.create(:route, :player => player)
      @params = {'id' => @route.id}
    end

    @required_params = %w{id}
    it_should_behave_like "with param options"

    it "should check player" do
      route = Factory.create(:route)
      lambda do
        invoke @action, @params.merge('id' => route.id)
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should should destroy route" do
      invoke @action, @params
      lambda do
        @route.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end
end