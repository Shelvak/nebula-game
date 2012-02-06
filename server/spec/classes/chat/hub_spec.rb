require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Chat::Hub do
  before(:each) do
    @dispatcher = mock(Dispatcher)
    @dispatcher.stub!(:transmit).and_return(true)
    @dispatcher.stub!(:push).and_return(true)
    @hub = Chat::Hub.new(@dispatcher)
    @antiflood = @hub.instance_variable_get("@antiflood")
    @control = @hub.instance_variable_get("@control")
  end

  describe ".new" do
    it "should create antiflood along with hub" do
      Chat::AntiFlood.should_receive(:new).with(@dispatcher)
      Chat::Hub.new(@dispatcher)
    end
  end

  describe "#register" do
    before(:each) do
      @player = Factory.create(:player)
      @dispatcher.stub!(:connected?).with(@player.id).and_return(true)
    end

    it "should join to galaxy channel" do
      @hub.register(@player)
      @hub.joined?(@player, Chat::Hub::GLOBAL_CHANNEL).should be_true
    end

    it "should not join to language channel if it uses global channel " +
    "language" do
      @player.language = Chat::Hub::GLOBAL_CHANNEL_LANGUAGE
      @hub.should_not_receive(:join).with(@player.language, @player)
      @hub.register(@player)
    end

    it "should join to language channel" do
      @player.language = 'lt'
      @hub.register(@player)
      @hub.joined?(@player, @player.language).should be_true
    end

    it "should not join player to alliance channel if he's not in alliance" do
      @hub.register(@player)
      lambda do
        @hub.joined?(@player, "alliance-")
      end.should raise_error(ArgumentError)
    end

    it "should join player to alliance channel if he's in alliance" do
      player = Factory.create(:player,
        :alliance => Factory.create(:alliance))

      @hub.register(player)
      @hub.joined?(player, 
        @hub.class.alliance_channel_name(player.alliance_id)).should \
        be_true
    end
  end

  describe "#unregister" do
    before(:each) do
      @player = Factory.create(:player)
      @dispatcher.stub!(:connected?).with(@player.id).and_return(true)
      @hub.register(@player)
    end

    it "should leave from galaxy channel" do
      @hub.unregister(@player)
      @hub.joined?(@player, Chat::Hub::GLOBAL_CHANNEL).should be_false
    end

    it "should not try to leave language channel if it uses same " +
    "language as global channel" do
      @player.language = Chat::Hub::GLOBAL_CHANNEL_LANGUAGE
      @hub.should_not_receive(:leave).with(@player.language, @player)
      @hub.unregister(@player)
    end

    it "should leave from language channel" do
      @hub.unregister(@player)
      @player.language = 'lt'
      @hub.register(@player)
      @hub.unregister(@player)
      @hub.joined?(@player, @player.language).should be_false
    end

    it "should not leave alliance channel if he's not in alliance" do
      @hub.should_not_receive(:leave).with("alliance-", @player)
      @hub.unregister(@player)
    end

    it "should join player to alliance channel if he's in alliance" do
      player = Factory.create(:player,
        :alliance => Factory.create(:alliance))
      @hub.register(player)

      @hub.unregister(player)
      @hub.joined?(player, 
        @hub.class.alliance_channel_name(player.alliance_id)).should \
        be_false
    end
  end

  describe "#send_stored!" do
    before(:each) do
      @player = Factory.create(:player)
      @dispatcher.stub!(:connected?).with(@player.id).and_return(true)

      @source = Factory.create(:player)
      @dispatcher.stub!(:connected?).with(@source.id).and_return(false)

      Chat::Message.store!(@source.id, @player.id, "FOO")
      Chat::Message.store!(@source.id, @player.id, "bar")
      Chat::Message.store!(@source.id, @player.id, "baz")
    end

    it "should retrieve! them" do
      @hub.send_stored!(@player)
      Chat::Message.retrieve(@player.id).should be_blank
    end

    it "should dispatch them" do
      Chat::Message.retrieve(@player.id).each do |message|
        @hub.should_receive(:private_msg).with(
          message['source_id'], @player.id, message['message'],
          message['created_at']
        )
      end
      @hub.send_stored!(@player)
    end
  end

  describe "#channels" do
    it "should return channels for player" do
      player = Factory.create(:player)
      @hub.register(player)
      channels = @hub.channels(player.id)
      channels.should_not be_blank
      channels.each do |channel|
        channel.should be_instance_of(Chat::Channel)
      end
    end
  end

  describe "#players" do
    it "should return players for default channel" do
      player = Factory.create(:player, :language => 'lt')
      @hub.register(player)
      player2 = Factory.create(:player, :language => 'it')
      @hub.register(player2)
      @hub.players.should == [player, player2]
    end
  end

  describe "#channel_msg" do
    before(:each) do
      @player = Factory.create(:player)
    end

    it "should raise error if channel is unknown" do
      lambda do
        @hub.channel_msg("OMG", @player, "OMG")
      end.should raise_error(ArgumentError)
    end

    describe "registered to channel" do
      before(:each) do
        @hub.register(@player)
        @channel = @hub.instance_variable_get("@channels")[
          Chat::Hub::GLOBAL_CHANNEL
        ]
      end

      it "should check with control" do
        @control.should_receive(:message).with(@player, "test")
        @hub.channel_msg(Chat::Hub::GLOBAL_CHANNEL, @player, "test")
      end

      it "should return false if it is a control message" do
        @control.should_receive(:message).with(@player, "test").and_return(true)
        @hub.channel_msg(Chat::Hub::GLOBAL_CHANNEL, @player, "test").
          should be_false
      end

      it "should return true if it is not a control message" do
        @control.should_receive(:message).with(@player, "test").
          and_return(false)
        @hub.channel_msg(Chat::Hub::GLOBAL_CHANNEL, @player, "test").
          should be_true
      end

      it "should check with antiflood" do
        @antiflood.should_receive(:message!).with(@player.id)
        @hub.channel_msg(Chat::Hub::GLOBAL_CHANNEL, @player, "test")
      end

      it "should send message to channel" do
        msg = "OMG"
        @channel.should_receive(:message).with(@player, msg)
        @hub.channel_msg(Chat::Hub::GLOBAL_CHANNEL, @player, msg)
      end

      it "should return true" do
        @hub.channel_msg(Chat::Hub::GLOBAL_CHANNEL, @player, "test").
          should be_true
      end
    end
  end

  describe "#private_msg" do
    before(:each) do
      @source = Factory.create(:player)
      @target = Factory.create(:player)
      @message = "OMG"
      @dispatcher.stub(:connected?)
    end

    describe "target player is connected" do
      before(:each) do
        @dispatcher.should_receive(:connected?).with(@target.id).
          at_least(1).and_return(true)
      end

      it "should not check with antiflood if stamp is provided" do
        @antiflood.should_not_receive(:message!).with(@source.id)
        @hub.private_msg(@source.id, @target.id, @message, Time.now)
      end

      it "should check with antiflood if timestamp is not provided" do
        @antiflood.should_receive(:message!).with(@source.id)
        @hub.private_msg(@source.id, @target.id, @message)
      end

      it "should return true" do
        @hub.private_msg(@source.id, @target.id, @message).should be_true
      end

      describe "source player is not connected" do
        before(:each) do
          @dispatcher.should_receive(:connected?).with(@source.id).
            at_least(1).and_return(false)
        end

        it "should add name & stamp to params" do
          stamp = 10.minutes.ago
          @dispatcher.should_receive(:transmit).with(
            {
              'action' => ChatController::PRIVATE_MESSAGE,
              'params' => {
                'pid' => @source.id,
                'msg' => @message,
                'name' => @source.name,
                'stamp' => stamp.as_json
              }
            },
            @target.id
          )
          @hub.private_msg(@source.id, @target.id, @message, stamp)
        end

        it "should cache player name" do
          stamp = 10.minutes.ago
          @hub.private_msg(@source.id, @target.id, @message, stamp)
          Player.connection.should_not_receive(:select_value)
          @hub.private_msg(@source.id, @target.id, @message, stamp)
        end
      end

      describe "source player is connected" do
        before(:each) do
          @dispatcher.should_receive(:connected?).with(@source.id).
            and_return(true)
        end

        it "should transmit message to player" do
          @dispatcher.should_receive(:transmit).with(
            {
              'action' => ChatController::PRIVATE_MESSAGE,
              'params' => {'pid' => @source.id, 'msg' => @message}
            },
            @target.id
          )
          @hub.private_msg(@source.id, @target.id, @message)
        end
      end
    end

    describe "target player is not connected" do
      describe "if directed to system player" do
        let(:target_id) { Chat::Control::SYSTEM_ID }

        it "should check with the control" do
          @control.should_receive(:message).with(@source, @message)
          @hub.private_msg(@source.id, target_id, @message)
        end

        it "should not store any messages" do
          Chat::Message.should_not_receive(:store!)
          @hub.private_msg(@source.id, target_id, @message)
        end

        it "should return false" do
          @hub.private_msg(@source.id, target_id, @message).should be_false
        end
      end

      describe "if directed to normal player" do
        before(:each) do
          @dispatcher.should_receive(:connected?).with(@target.id).
            and_return(false)
        end

        it "should store message" do
          Chat::Message.should_receive(:store!).with(
            @source.id, @target.id, @message)
          @hub.private_msg(@source.id, @target.id, @message)
        end

        it "should return true" do
          @hub.private_msg(@source.id, @target.id, @message).should be_true
        end
      end
    end
  end

  describe "#on_alliance_change" do
    it "should leave old alliance channel if he was in alliance" do
      alliance = Factory.create(:alliance)
      player = Factory.create(:player, :alliance => alliance)
      @hub.register(player)
      player.alliance = nil

      @hub.should_receive(:leave).with(
        @hub.class.alliance_channel_name(alliance.id), player)
      @hub.on_alliance_change(player)
    end

    it "should join new alliance channel if he's in new alliance" do
      alliance = Factory.create(:alliance)
      new_alliance = Factory.create(:alliance)
      player = Factory.create(:player, :alliance => alliance)
      @hub.register(player)
      player.alliance = new_alliance

      @hub.should_receive(:join).with(
        @hub.class.alliance_channel_name(new_alliance.id), player)
      @hub.on_alliance_change(player)
    end

    it "should not leave old alliance channel if he was not in alliance" do
      new_alliance = Factory.create(:alliance)
      player = Factory.create(:player)
      @hub.register(player)
      player.alliance = new_alliance

      @hub.should_not_receive(:leave)
      @hub.on_alliance_change(player)
    end

    it "should not join any new channel if he now is not in alliance" do
      alliance = Factory.create(:alliance)
      player = Factory.create(:player, :alliance => alliance)
      @hub.register(player)
      player.alliance = nil

      @hub.should_not_receive(:join)
      @hub.on_alliance_change(player)
    end

    it "should not fail if player is not connected" do
      alliance = Factory.create(:alliance)
      player = Factory.create(:player, :alliance => alliance)
      player.alliance = Factory.create(:alliance)

      @hub.should_not_receive(:leave)
      @hub.should_not_receive(:join)
      @hub.on_alliance_change(player)
    end
  end

  describe "#on_language_change" do
    it "should leave old channel" do
      player = Factory.create(:player, :language => 'it')
      @hub.register(player)
      player.language = 'lt'
      @hub.on_language_change(player)
      @hub.joined?(player, 'it').should be_false
    end

    it "should join new channel" do
      player = Factory.create(:player, :language => 'it')
      @hub.register(player)
      player.language = 'lt'
      @hub.on_language_change(player)
      @hub.joined?(player, 'lt').should be_true
    end

    it "should not leave old channel if it uses default language" do
      player = Factory.create(:player,
        :language => Chat::Hub::GLOBAL_CHANNEL_LANGUAGE)
      @hub.register(player)
      player.language = 'lt'
      @hub.should_not_receive(:leave).with(
        Chat::Hub::GLOBAL_CHANNEL_LANGUAGE, player)
      @hub.on_language_change(player)
    end

    it "should not join new channel if it uses default language" do
      player = Factory.create(:player, :language => 'lt')
      @hub.register(player)
      player.language = Chat::Hub::GLOBAL_CHANNEL_LANGUAGE
      @hub.should_not_receive(:join).with(
        Chat::Hub::GLOBAL_CHANNEL_LANGUAGE, player)
      @hub.on_language_change(player)
    end

    it "should not fail if player is not connected" do
      player = Factory.create(:player, :language => 'lt')
      player.language = 'cz'
      @hub.should_not_receive(:leave)
      @hub.should_not_receive(:join)
      @hub.on_language_change(player)
    end
  end
end