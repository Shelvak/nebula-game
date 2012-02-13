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
      @params = {'id' => @combat_log.sha1_id}
    end

    it_behaves_like "with param options", %w{id}

    it "should return log" do
      invoke @action, @params
      response_should_include(
        :log => @combat_log.info
      )
    end

    it "should fail with ActiveRecord::RecordNotFound if log cannot be found" do
      @combat_log.destroy!
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end
end