require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe ResourcesController do
  include ControllerSpecHelper

  before(:each) do
    init_controller ResourcesController, :login => true
  end

  describe "resources|index" do
    before(:each) do
      @planet = Factory.create(:planet, :player => player)
      @action = "resources|index"
      @params = {'resources_entry' => @planet.resources_entry}
      @method = :push
    end

    @required_params = %w{resources_entry}
    it_should_behave_like "with param options"
    it_should_behave_like "only push"

    it "should return resources entry" do
      should_respond_with :resources_entry => @planet.resources_entry
      push @action, @params
    end
  end
end