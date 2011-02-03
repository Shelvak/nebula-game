require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Dispatcher do
  before(:each) do
    @dispatcher = Dispatcher.send :new
  end

  describe "as a class" do
    describe ".singleton" do
      it "should always return same object" do
        Dispatcher.instance.object_id.should == Dispatcher.instance.object_id
      end
    end
  end

  describe "#register" do
    before(:each) do
      @io, @id = dispatcher_register_client(@dispatcher, 'IO')
    end

    it "should map IO to client number" do
      @id.should_not be_nil
    end

    it "should map client number to IO" do
      @dispatcher.instance_variable_get("@client_id_to_io")[@id].should eql(@io)
    end

    it "should create empty storage container" do
      @dispatcher.storage[@id].should == {}
    end
  end

  describe "unregistering in message queue processing" do
    before(:each) do
      @io1 = mock(IO)
      @io1.stub!(:send_message)
      @io1.stub!(:close_connection_after_writing)
      @io2 = mock(IO)
      @io2.stub!(:send_message)
      @io2.stub!(:close_connection_after_writing)

      @dispatcher.register @io1
      @dispatcher.register @io2

      @id1 = @dispatcher.instance_variable_get("@io_to_client_id")[@io1]
      @id2 = @dispatcher.instance_variable_get("@io_to_client_id")[@io2]

      @dispatcher.stub!(:process_queue).and_return(true)

      @dispatcher.receive(@io1, {'action' => "c1-a1"})
      @dispatcher.receive(@io2, {'action' => "c2-a1"})
      @dispatcher.receive(@io1, {'action' => "c1-a2"})
      @dispatcher.receive(@io2, {'action' => "c2-a2"})

      @dispatcher.disconnect(@io1)
    end

    it "should remove client 1 messages from queue" do
      @dispatcher.instance_variable_get("@message_queue").find do |msg|
        msg['client_id'] == @id1
      end.should be_nil
    end

    it "should keep client 2 messages in queue" do
      @dispatcher.instance_variable_get("@message_queue").reject do |msg|
        msg['client_id'] != @id2
      end.size.should == 2
    end
  end

  describe "#unregister" do
    before(:each) do
      @io = 'IO'
      @player = Factory.create(:player)
      @dispatcher.register @io
      @id = @dispatcher.instance_variable_get("@io_to_client_id")[@io]
      @dispatcher.change_player(@id, @player)
      
      @dispatcher.unregister @io
    end

    it "should clean up io_to_client" do
      @dispatcher.instance_variable_get("@io_to_client_id")[@io].should be_nil
    end

    %w{
      client_id_to_player client_id_to_io storage
    }.each do |storage|
      it "should clean up #{storage}" do
        @dispatcher.instance_variable_get("@#{storage}")[@id].should be_nil
      end
    end
  end

  describe "#change_client_id" do
    before(:each) do
      @io = 'IO'
      @dispatcher.register @io
      @id = @dispatcher.instance_variable_get("@io_to_client_id")[@io]
      @change_id = 123
      @dispatcher.send(:change_client_id, @id, @change_id)
    end

    it "should call disconnect_client(id, false) if one is " +
    "already connected" do
      io = 'IO2'
      @dispatcher.register io
      client_id = @dispatcher.instance_variable_get("@io_to_client_id")[io]
      @dispatcher.should_receive(:disconnect).with(
        @change_id, "other_login", false).and_return(true)
      @dispatcher.send(:change_client_id, client_id, @change_id)
    end

    it "should change ID in io_to_client" do
      @dispatcher.instance_variable_get("@io_to_client_id")[@io].should eql(@change_id)
    end

    it "should unassign old client_to_io id" do
      @dispatcher.instance_variable_get("@client_id_to_io")[@id].should be_nil
    end

    it "should assign new client_to_io id" do
      @dispatcher.instance_variable_get("@client_id_to_io")[@change_id].should eql(@io)
    end
  end

  describe "#disconnect" do
    before(:each) do
      @io = 'IO'
      @io.stub!(:send_message)
      @io.stub!(:close_connection_after_writing)
      @dispatcher.register @io
      @id = @dispatcher.instance_variable_get("@io_to_client_id")[@io]
    end

    it "should call transmit_by_io (called by id)" do
      @dispatcher.should_receive(:transmit_by_io).with(@io,
        {"action" => Dispatcher::ACTION_DISCONNECT,
          "params" => {"reason" => "other_login"}})
      @dispatcher.send(:disconnect, @id, "other_login")
    end

    it "should call transmit_by_io (called by io)" do
      @dispatcher.should_receive(:transmit_by_io).with(@io,
        {"action" => Dispatcher::ACTION_DISCONNECT,
          "params" => {"reason" => "other_login"}})
      @dispatcher.send(:disconnect, @io, "other_login")
    end

    it "should close connection" do
      @io.should_receive(:close_connection_after_writing)
      @dispatcher.send(:disconnect, @id)
    end
  end

  describe "#next_unknown_client_id" do
    it "should return negative number" do
      @dispatcher.send(:next_unknown_client_id).should be_< 0
    end

    it "should never return positive number " do
      @dispatcher.instance_eval("@unknown_client_id = 100")
      @dispatcher.send(:next_unknown_client_id).should be_< 0
    end
  end

  describe "#receive" do
    it "should disconnect if no controller handles the message" do
      io = 'io'
      message = {'action' => 'foo|bar'}
      client_id = -1
      @dispatcher.instance_variable_set("@io_to_client_id", {io => client_id})
      @dispatcher.stub!(:confirm_receive_by_io)
      @dispatcher.should_receive(:disconnect).with(client_id, "unhandled_message")
      @dispatcher.receive(io, message)
    end

    it "should drop messages without registered client" do
      @dispatcher.should_not_receive(:process_message)
      @dispatcher.should_not_receive(:confirm_receive_by_io)
      @dispatcher.receive('io', {})
    end

    [
      ActiveRecord::RecordNotFound.new,
      ActiveRecord::RecordInvalid.new(Factory.create(:player)),
      GameError.new
    ].each do |ex|
      it "should confirm with failed if #{ex.class.to_s} was raised" do
        io = :io
        message = {'client_id' => 1}

        @dispatcher.stub!(:assign_message_vars!)
        @dispatcher.stub!(:process_message).with(message).and_raise(ex)
        @dispatcher.should_receive(:confirm_receive_by_io).with(io,
          message, true)
        @dispatcher.receive(io, message)
      end
    end
  end

  describe "#change_player" do
    before(:each) do
      @client_id = 10
      @player = Factory.create(:player)
      @dispatcher.change_player(@client_id, @player)
    end

    it "should store client_id -> player association" do
      @dispatcher.instance_variable_get("@client_id_to_player")[
        @player.id].should == @player
    end

    it "should raise ArgumentError if player is not Player" do
      lambda do
        @dispatcher.change_player(@client_id, :foo)
      end.should raise_error(ArgumentError)
    end
  end

  describe "#push_to_player" do
    it "should not notify players that are not connected" do
      @dispatcher.should_not_receive :push
      @dispatcher.push_to_player(Factory.create(:player), {})
    end

    it "should push messages to connected players" do
      player = Factory.create(:player)
      io, client_id = dispatcher_register_player(@dispatcher, 'IO', player)
      message = {'action' => 'resources|index'}
      @dispatcher.should_receive(:push).with(message, client_id)
      @dispatcher.push_to_player player.id, message
    end

    it "should not push messages to connected players if filter does " +
    "not match" do
      player = Factory.create(:player)
      io, client_id = dispatcher_register_player(@dispatcher, 'IO', player)
      message = {'action' => 'resources|index'}

      filter = :filter

      @dispatcher.stub!(:push_filters_match?).with(client_id,
        filter).and_return(false)
      @dispatcher.should_not_receive(:push)
      @dispatcher.push_to_player player.id, message, {}, filter
    end

    it "should allow pushing action/params instead of message" do
      player = Factory.create(:player)
      io, client_id = dispatcher_register_player(@dispatcher, 'IO', player)
      action = 'resources|index'
      params = {'foo' => 'bar'}
      @dispatcher.should_receive(:push).with({
          'action' => action, 'params' => params
        }, client_id)
      @dispatcher.push_to_player player.id, action, params
    end
  end
end
