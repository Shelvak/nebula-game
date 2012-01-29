require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Chat::Channel do
  before(:each) do
    @dispatcher = mock(Dispatcher)
    @dispatcher.stub!(:push)
    @chan = Chat::Channel.new("c", @dispatcher)
  end

  describe "#players" do
    it "should return Array of players" do
      player = Factory.create(:player)
      @chan.join(player)
      @chan.players.should == [player]
    end
  end

  describe "#join" do
    let(:old_players) { [Factory.create(:player), Factory.create(:player)] }
    let(:player) { Factory.create(:player) }
    let(:players) { old_players + [player] }
    before(:each) do
      old_players.each { |player| @chan.join(player) }
    end

    it "should join player to channel" do
      @chan.join(player)
      @chan.has?(player).should be_true
    end

    it "should notify everybody (including self) about join" do
      players.each do |p|
        @dispatcher.should_receive(:push).with(
          {
            'action' => ChatController::ACTION_JOIN,
            'params' => {'channel' => @chan.name, 'player' => player}
          },
          p.id
        )
      end
      @chan.join(player)
    end

    it "should not notify self if asked not to" do
      @dispatcher.should_not_receive(:push).with(
        {
          'action' => ChatController::ACTION_JOIN,
          'params' => {'channel' => @chan.name, 'player' => player}
        },
        player.id
      )
      @chan.join(player, false)
    end

    it "should notify self about everybody who is in that channel" do
      old_players.each do |p|
        @dispatcher.should_receive(:push).with(
          {
            'action' => ChatController::ACTION_JOIN,
            'params' => {'channel' => @chan.name, 'player' => p}
          },
          player.id
        )
      end
      @chan.join(player)
    end

    it "should not notify self about everybody if asked not to" do
      old_players.each do |p|
        @dispatcher.should_not_receive(:push).with(
          {
            'action' => ChatController::ACTION_JOIN,
            'params' => {'channel' => @chan.name, 'player' => p}
          },
          player.id
        )
      end
      @chan.join(player, false)
    end
  end

  describe "#leave" do
    it "should throw player out of channel" do
      player = Factory.create(:player)
      @chan.join(player)
      @chan.leave(player)
      @chan.has?(player).should be_false
    end

    it "should complain if player is not in channel" do
      player = Factory.create(:player)
      lambda do
        @chan.leave(player)
      end.should raise_error(ArgumentError)
    end

    it "should notify all (including self) about leaving" do
      @dispatcher.stub!(:push)

      old_player = Factory.create(:player)
      @chan.join(old_player)
      player = Factory.create(:player)
      @chan.join(player)
      [old_player, player].each do |p|
        @dispatcher.should_receive(:push).with(
          {
            'action' => ChatController::ACTION_LEAVE,
            'params' => {'channel' => @chan.name, 'player' => player}
          },
          p.id
        )
      end
      @chan.leave(player)
    end

    it "should not notify self if asked not to" do
      @dispatcher.stub!(:push)

      old_player = Factory.create(:player)
      @chan.join(old_player)
      player = Factory.create(:player)
      @chan.join(player)
      @dispatcher.should_not_receive(:push).with(
        {
          'action' => ChatController::ACTION_LEAVE,
          'params' => {'channel' => @chan.name, 'player' => player}
        },
        player.id
      )
      @chan.leave(player, false)
    end
  end

  describe "#message" do
    it "should fail if player has not joined the channel" do
      player = Factory.create(:player)
      lambda do
        @chan.message(player, "FOO")
      end.should raise_error(ArgumentError)
    end

    it "should dispatch message to every player except self" do
      player = Factory.create(:player)
      player2 = Factory.create(:player)
      @chan.join(player)
      @chan.join(player2)

      msg = "FOO"
      @dispatcher.should_receive(:transmit).with(
        {
          'action' => ChatController::CHANNEL_MESSAGE,
          'params' => {'chan' => @chan.name, 'pid' => player.id,
            'msg' => msg}
        },
        player2.id
      )
      @chan.message(player, msg)
    end
  end
end