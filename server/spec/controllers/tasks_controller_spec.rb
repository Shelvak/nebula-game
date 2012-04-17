require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe TasksController do
  include ControllerSpecHelper

  before(:each) do
    init_controller TasksController, :login => true
    @params = {
      GenericController::ParamOpts::CONTROL_TOKEN_KEY => Cfg.control_token
    }
    restore_logging
  end

  describe "tasks|reopen_logs" do
    before(:each) do
      @action = "tasks|reopen_logs"
    end

    it_should_behave_like "with param options",
      :needs_login => false, :needs_control_token => true

    it "should not fail" do
      invoke @action, @params
    end

    it "should call #reopen! on log writer" do
      Logging::Writer.instance.should_receive(:reopen!)
      invoke @action, @params
    end
  end

  describe "tasks|create_galaxy" do
    let(:ruleset) { 'default' }
    let(:callback_url) { "http://nebula44.test/" }

    before(:each) do
      @action = "tasks|create_galaxy"
      @params.merge!('ruleset' => ruleset, 'callback_url' => callback_url)
    end

    it_should_behave_like "with param options",
      :required => %w{ruleset callback_url},
      :needs_login => false, :needs_control_token => true

    it "should call Galaxy.create_galaxy" do
      Galaxy.should_receive(:create_galaxy).with(ruleset, callback_url)
      invoke @action, @params
    end

    it "should return created galaxy id" do
      invoke @action, @params
      Galaxy.find(response[:galaxy_id]).should_not be_nil
    end

    it "should work" do
      invoke @action, @params
    end
  end
end