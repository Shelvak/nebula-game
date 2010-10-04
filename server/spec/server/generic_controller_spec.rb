require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe GenericController do
  include ControllerSpecHelper
  
  before(:each) do
    init_controller GenericController
  end

  describe "#only_push!" do
    it "should do nothing if request is pushed" do
      @controller.stub!(:invoke)
      @controller.receive({'action' => 'foo', 'params' => {'aa' => 10},
        'pushed' => true})
      lambda { @controller.send(:only_push!) }.should_not raise_error
    end

    it "should raise GenericController::PushRequired if request is not pushed" do
      @controller.stub!(:invoke)
      @controller.receive({'action' => 'foo', 'params' => {'aa' => 10}})
      lambda { @controller.send(:only_push!) }.should raise_error(
        GenericController::PushRequired)
    end
  end

  describe "#param_options" do
    before(:each) do
      @controller.stub!(:invoke)
    end

    it "should raise ControllerArgumentError if required param " +
    "is missing" do
      lambda do
        @controller.receive({'action' => 'foo', 'params' => {'aa' => 10}})
        @controller.send :param_options, :required => 'lol'
      end.should raise_error(ControllerArgumentError)
    end

    it "should pass if required params is given" do
      lambda do
        @controller.receive({'action' => 'foo', 'params' => {'lol' => 10}})
        @controller.send :param_options, :required => 'lol'
      end.should_not raise_error(ArgumentError)
    end

    it "should raise ArgumentError if param is not from valid list" do      
      lambda do
        @controller.receive({'action' => 'foo', 'params' => {'aa' => 10}})
        @controller.send :param_options, :valid => 'lol'
      end.should raise_error(ArgumentError)
    end

    it "should pass if params are from valid list" do
      lambda do
        @controller.receive({'action' => 'foo', 'params' => {'lol' => 10}})
        @controller.send :param_options, :valid => 'lol'
      end.should_not raise_error(ArgumentError)
    end

    it "should pass if all params are valid and required are provided" do
      lambda do
        @controller.receive({'action' => 'foo', 'params' => {'baz' => 10,
            'lol' => 20}})
        @controller.send :param_options, :valid => 'lol', :required => 'baz'
      end.should_not raise_error(ArgumentError)
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
      @controller.stub!(:invoke).and_return(true)

      @params = {'key' => 'value'}
      @player = Factory.create :player
      @message = {
        'id' => 1,
        'action' => 'foo|bar',
        'client_id' => -1,
        'user' => @player.user,
        'player' => @player,
        'params' => @params
      }
    end

    it "should set @current_message" do
      @controller.receive(@message)
      @controller.instance_variable_get("@current_message").should == @message
    end

    %w{client_id user player params}.each do |attr|
      it "should set @#{attr}" do
        @controller.receive(@message)
        @controller.instance_variable_get("@#{attr}").should == @message[attr]
      end
    end

    it "should pass {} as params if they're missing" do
      @controller.receive(@message.merge('params' => nil))
      @controller.instance_variable_get("@params").should == {}
    end

    it "should call invoke" do
      @controller.should_receive(:invoke).with(@message['action'])
      @controller.receive(@message.merge('params' => nil))
    end

    it "should scope config in ruleset" do
      CONFIG.should_receive(:with_set_scope).with(@player.galaxy.ruleset)
      @controller.receive(@message)
    end
  end

  describe "#login" do
    before(:each) do
      @user = Factory.create(:user)
    end

    it "should raise ArgumentError if argument is not user" do
      lambda { @controller.login :foo }.should raise_error(ArgumentError)
    end

    it "should update @client_id" do
      lambda { @controller.login @user }.should change(
        @controller, :client_id).to(@user.id)
    end

    it "should update @user" do
      lambda { @controller.login @user }.should change(
        @controller, :user).to(@user)
    end

    it "should invoke @dispatcher.change_user" do
      @dispatcher.should_receive(:change_user).with(client_id, @user)
      @controller.login @user
    end
  end

  describe "#assign_player" do
    before(:all) do
      @player = Factory.create :player
    end

    it "should raise ArgumentError if argument is not player" do
      lambda { @controller.assign_player :foo }.should raise_error(ArgumentError)
    end

    it "should update @player" do
      lambda { @controller.assign_player @player }.should change(
        @controller, :player).to(@player)
    end

    it "should invoke @dispatcher.associate_player" do
      @dispatcher.should_receive(:associate_player).with(@controller.client_id, @player)
      @controller.assign_player @player
    end
  end

  describe "#in_role?" do
    it "should call user.in_role?" do
      @controller.login(Factory.create(:user))
      role = User::ROLE_ADMIN
      @controller.user.should_receive(:in_role?).with(role)
      @controller.in_role?(role)
    end
  end

  describe "#admin?" do
    it "should call self.in_role?(User::ROLE_ADMIN)" do
      @controller.should_receive(:in_role?).with(User::ROLE_ADMIN)
      @controller.admin?
    end
  end
end