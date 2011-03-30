require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe ChatController do
  include ControllerSpecHelper

  before(:each) do
    init_controller ChatController, :login => true
  end

  describe "chat|index" do
    before(:each) do
      @action = "chat|index"
      @params = {}
      @hub = Chat::Pool.instance.hub_for(player)
      @hub.register(player)
    end

    it_should_behave_like "only push"

    it "should respond with channels" do
      push @action, @params
      response[:channels].should have_key(Chat::Hub::GLOBAL_CHANNEL)
    end

    it "should have id, name pairs in those channels" do
      push @action, @params
      response[:channels][Chat::Hub::GLOBAL_CHANNEL].should == [
        [player.id, player.name]
      ]
    end
  end

  describe "chat|join" do
    before(:each) do
      @action = "chat|join"
      @player = Factory.create(:player)
      @params = {'channel' => 'foo', 'player' => @player}
      @method = :push
    end

    @required_params = %w{channel player}
    it_should_behave_like "with param options"
    it_should_behave_like "only push"

    it "should have channel name" do
      push @action, @params
      response_should_include(:chan => @params['channel'])
    end

    it "should have player id" do
      push @action, @params
      response_should_include(:pid => @player.id)
    end

    it "should have player name" do
      push @action, @params
      response_should_include(:name => @player.name)
    end
  end

  describe "chat|leave" do
    before(:each) do
      @action = "chat|leave"
      @player = Factory.create(:player)
      @params = {'channel' => 'foo', 'player' => @player}
      @method = :push
    end

    @required_params = %w{channel player}
    it_should_behave_like "with param options"
    it_should_behave_like "only push"

    it "should have channel name" do
      push @action, @params
      response_should_include(:chan => @params['channel'])
    end

    it "should have player id" do
      push @action, @params
      response_should_include(:pid => @player.id)
    end
  end

  # This action is not pushed via regular Dispatcher#push but instead
  # transmitted directly via Dispatcher#transmit from +Chat::Hub+ for
  # performance reasons. Because of that we only test client invocation
  # here.
  describe "chat|c" do
    before(:each) do
      @action = "chat|c"
      @params = {'chan' => 'c', 'msg' => 'omg wtf lol!'}
    end

    @required_params = %w{chan msg}
    it_should_behave_like "with param options"

    it "should invoke #channel_msg on hub" do
      hub = mock(Chat::Hub)
      Chat::Pool.instance.should_receive(:hub_for).with(player).
        and_return(hub)
      hub.should_receive(:channel_msg).with(@params['chan'], player,
        @params['msg'])
      invoke @action, @params
    end
  end

  # See 'chat|c' test.
  describe "chat|m" do
    before(:each) do
      @action = "chat|m"
      @params = {'pid' => 10, 'msg' => 'omg wtf lol!'}
    end

    @required_params = %w{pid msg}
    it_should_behave_like "with param options"

    it "should invoke #private_msg on hub" do
      hub = mock(Chat::Hub)
      Chat::Pool.instance.should_receive(:hub_for).with(player).
        and_return(hub)
      hub.should_receive(:private_msg).with(player.id, @params['pid'], 
        @params['msg'])
      invoke @action, @params
    end
  end
end