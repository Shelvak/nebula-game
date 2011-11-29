require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe CombatLogsController do
  include ControllerSpecHelper

  before(:each) do
    init_controller CombatLogsController, :login => false
  end

  describe "combat_logs|show" do
    before(:each) do
      @action = "combat_logs|show"
      @combat_log = Factory.create :combat_log
      @params = {'id' => @combat_log.id}
    end

    it_behaves_like "with param options", %w{id}

    it "should return log" do
      should_respond_with :log => @combat_log.info
      invoke @action, @params
    end
  end
end