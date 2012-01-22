require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Chat::AntiFlood do
  let(:dispatcher) do
    dispatcher = mock(Dispatcher)
    dispatcher.stub!(:push_to_player)
    dispatcher
  end
  let(:antiflood) { Chat::AntiFlood.new(dispatcher) }
  let(:msg_count) { Cfg.chat_antiflood_messages }
  let(:period) { Cfg.chat_antiflood_period }
  let(:player_id) { 10 }

  describe "#message!" do
    it "should not silence player if he is not flooding" do
      dispatcher.should_not_receive(:push_to_player)

      msg_count.times do |i|
        antiflood.message!(player_id, Time.now + period * i)
      end
      antiflood.message!(player_id, Time.now + period * (msg_count + 1))
    end

    it "should silence player if he is flooding" do
      silence_until = Cfg.chat_antiflood_silence_for(1).from_now
      dispatcher.should_receive(:push_to_player).with(
        player_id, ChatController::ACTION_SILENCE, {'until' => silence_until}
      )

      (msg_count + 1).times { antiflood.message!(player_id) }
    end

    it "should raise error if player is silenced" do
      (msg_count + 1).times { antiflood.message!(player_id) }
      lambda do
        antiflood.message!(player_id)
      end.should raise_error(GameLogicError)
    end

    it "should allow messaging again after silence has expired" do
      Cfg.stub(:chat_antiflood_silence_for).and_return(-1)
      (msg_count + 1).times { antiflood.message!(player_id) }

      antiflood.message!(player_id)
    end

    it "should increase silence time by formula" do
      Cfg.stub(:chat_antiflood_silence_for).and_return(-1)
      (msg_count + 1).times { antiflood.message!(player_id) }

      Cfg.should_receive(:chat_antiflood_silence_for).with(2).and_return(-1)
      (msg_count + 1).times { antiflood.message!(player_id) }
    end
  end
end