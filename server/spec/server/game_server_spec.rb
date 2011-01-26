require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

class GameServerTest
  include GameServer
end

describe GameServer do
  before(:each) do
    @game_server = GameServerTest.new
    @dispatcher = mock(Dispatcher)
    @dispatcher.stub!(:disconnect)
    Dispatcher.stub!(:instance).and_return(@dispatcher)
  end

  describe "#post_init" do
    it "should register itself to dispatcher" do
      @game_server.stub!(:get_client_addr).and_return([1234, "127.0.0.1"])
      @dispatcher.should_receive(:register).with(@game_server)
      @game_server.post_init
    end
  end

  describe "#unbind" do
    it "should unregister itself from dispatcher" do
      @dispatcher.should_receive(:unregister).with(@game_server)
      @game_server.unbind
    end
  end

  describe "#receive_data" do
    it "should disconnect anything if data = ''" do
      @dispatcher.should_receive(:disconnect).with(@game_server, "empty_message")
      @game_server.receive_data("")
    end

    it "should pass decoded data to dispatcher" do
      data = '{"action": "test|test"}'
      @dispatcher.should_receive(:receive).with(@game_server, JSON.parse(data))
      @game_server.receive_data(data)
    end

    describe "when data doesn't parse out as JSON" do
      it "should disconnect client" do
        @dispatcher.should_receive(:disconnect).with(@game_server, "json_error")
        @game_server.receive_data("LOL")
      end

      it "should write exception to logger" do
        LOGGER.should_receive(:debug).with(an_instance_of(String), @game_server.to_s)
        @game_server.receive_data('LOL')
      end
    end

    describe "when regular Exception occurs" do
      before(:each) do
        @dispatcher.stub!(:receive).and_raise(Exception)
      end

      it "should disconnect client" do
        @dispatcher.should_receive(:disconnect).with(@game_server, "server_error")
        @game_server.receive_data('{"id": 1}')
      end

      it "should write exception to logger" do
        LOGGER.should_receive(:error).with(an_instance_of(String),
          @game_server.to_s)
        @game_server.receive_data('{"id": 1}')
      end
    end
  end
end

