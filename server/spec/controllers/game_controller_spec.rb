require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe GameController do
  include ControllerSpecHelper

  before(:each) do
    init_controller GameController, :login => true
  end

  describe "game|config" do
    before(:each) do
      @action = "game|config"
      @params = {}
    end

    it "should have config filtered by regexp" do
      invoke @action
      response[:config].should equal_to_hash(
        CONFIG.constantize_speed(CONFIG.filter(GameController::SENDABLE_RE))
      )
    end

    it "should replace speed with constant" do
      with_config_values 'units.foo' => '10 / speed * level' do
        invoke @action, @params
        response[:config]['units.foo'].should == "10 / #{
          CONFIG['speed']} * level"
      end
    end

    it "should recognize different rulesets" do
      with_config_values 'units.foo' => '10 / speed' do
        invoke @action, @params
        default_value = response[:config]['units.foo']

        session[:ruleset] = 'hyper'
        invoke @action, @params
        response[:config]['units.foo'].should_not == default_value
      end
    end
  end
end