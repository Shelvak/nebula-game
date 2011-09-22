require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe GenericController do
  include ControllerSpecHelper
  
  before(:each) do
    init_controller GenericController
  end

  describe "#only_push!" do
    before(:each) do
      @controller.stub!(:before_invoke!).and_return(true)
      @controller.stub!(:action_known!).and_return(true)
      @controller.stub!(:action_bar).and_return(true)
      @action = 'foo|bar'
    end

    it "should do nothing if request is pushed" do
      @controller.receive('action' => @action, 'params' => {'aa' => 10},
        'pushed' => true)
      lambda { @controller.send(:only_push!) }.should_not raise_error
    end

    it "should raise GenericController::PushRequired if request is not pushed" do
      @controller.receive('action' => @action, 'params' => {'aa' => 10})
      lambda { @controller.send(:only_push!) }.should raise_error(
        GenericController::PushRequired)
    end
  end

  describe "#param_options" do
    before(:each) do
      @controller.instance_eval do
        @known_actions = %w{bar}
      end
      @controller.stub!(:before_invoke!).and_return(true)
      @controller.stub!(:action_bar).and_return(true)
      @params = {'aa' => 10}
      @controller.receive('action' => 'foo|bar', 'params' => @params)
    end

    it "call #ensure_options! on params" do
      options = {:required => 'lol'}
      @params.should_receive(:ensure_options!).with(options)
      @controller.send :param_options, options
    end

    it "call raise ControllerArgumentError if #ensure_options! raises error" do
      options = {:required => 'lol'}
      @params.should_receive(:ensure_options!).with(options).
        and_raise(ArgumentError)
      lambda do
        @controller.send :param_options, options
      end.should raise_error(ControllerArgumentError)
    end
  end

  describe "#disconnect" do
    it "should call @dispatcher.disconnect" do
      message = 'lol message'
      @dispatcher.should_receive(:disconnect).with(an_instance_of(Fixnum), message)
      @controller.disconnect message
    end
  end

  describe "#receive" do
    before(:each) do
      @player = Factory.create :player

      @controller.instance_eval do
        @known_actions = ['bar']
      end
      @controller.stub!(:action_bar)
      @controller.session[:ruleset] = @player.galaxy.ruleset

      @params = {'key' => 'value'}
      @message = {
        'id' => 1,
        'action' => 'foo|bar',
        'client_id' => -1,
        'player' => @player,
        'params' => @params
      }
    end

    it "should set @current_message" do
      @controller.receive(@message)
      @controller.instance_variable_get("@current_message").should == @message
    end

    %w{client_id player params}.each do |attr|
      it "should set @#{attr}" do
        @controller.receive(@message)
        @controller.instance_variable_get("@#{attr}").should == @message[attr]
      end
    end

    it "should pass {} as params if they're missing" do
      @controller.receive(@message.merge('params' => nil))
      @controller.instance_variable_get("@params").should == {}
    end

    it "should call action" do
      @controller.should_receive(:action_bar).once
      @controller.receive(@message.merge('params' => nil))
    end

    it "should scope config in ruleset" do
      CONFIG.should_receive(:with_set_scope).with(
        @controller.session[:ruleset])
      @controller.receive(@message)
    end

    it "should raise error if it was filtered" do
      @controller.should_receive(:before_invoke!).and_return(false)
      lambda do
        @controller.receive(@message)
      end.should raise_error(GenericController::ActionFiltered)
    end

    it "should raise error if it is unknown action" do
      lambda do
        @controller.receive(@message.merge('action' => 'foo|baz'))
      end.should raise_error(GenericController::UnknownAction)
    end
  end

  describe "#login" do
    before(:each) do
      @player = Factory.create(:player)
    end

    it "should raise ArgumentError if argument is not user" do
      lambda { @controller.login :foo }.should raise_error(ArgumentError)
    end

    it "should update last login in player" do
      lambda do
        @controller.login @player
      end.should change(@player, :last_login)
    end

    it "should update @client_id" do
      lambda { @controller.login @player }.should change(
        @controller, :client_id).to(@player.id)
    end

    it "should update @player" do
      lambda { @controller.login @player }.should change(
        @controller, :player).to(@player)
    end

    it "should invoke @dispatcher.change_user" do
      @dispatcher.should_receive(:change_player).with(client_id, @player)
      @controller.login @player
    end
  end
end