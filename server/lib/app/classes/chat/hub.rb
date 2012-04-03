# Chat hub that holds channels and directs all message moving in the galaxy.
class Chat::Hub
  include MonitorMixin

  # Global channel which everybody joins
  GLOBAL_CHANNEL = 'galaxy'
  # Language for global channel.
  GLOBAL_CHANNEL_LANGUAGE = 'en'

  def initialize(dispatcher_actor_name)
    super
    typesig binding, Symbol

    @dispatcher_actor_name = dispatcher_actor_name
    @antiflood = Chat::AntiFlood.new(dispatcher_actor_name)
    @control = Chat::Control.new(dispatcher_actor_name, @antiflood)
    @channels = {
      GLOBAL_CHANNEL => Chat::Channel.new(GLOBAL_CHANNEL, dispatcher_actor_name)
    }
    # Cache of player_id => channel_names pairs
    @channels_cache = {}
    @names_cache = {}
  end

  # Channels to which this _player_id_ is joined.
  def channels(player_id)
    synchronize do
      (@channels_cache[player_id] || []).map { |name| @channels[name] }
    end
  end

  # Registers player to this hub.
  def register(player)
    synchronize do
      raise ArgumentError, "#{player} is already connected to #{self}!" \
        if connected?(player)
      join_or_leave(player, :join)
    end
  end

  # Unregisters player from this hub.
  def unregister(player)
    synchronize do
      raise ArgumentError, "#{player} is not connected to #{self}!" \
        unless connected?(player)
      join_or_leave(player, :leave)
    end
  end

  # Retrieve and send stored _player_ private messages. Clears the stored
  # messages.
  #
  # This sends immediately and does not go through push queue!
  def send_stored(player)
    synchronize do
      Chat::Message.retrieve!(player.id).each do |message|
        private_msg(
          message['source_id'], player.id, message['message'],
          message['created_at']
        )
      end
    end
  end

  # Array of +Player+s in this hub.
  def players
    synchronize do
      @channels[GLOBAL_CHANNEL].players
    end
  end

  # You should call this when Player#alliance_id changes.
  #
  # It depends on Player#alliance_id_change.
  def on_alliance_change(player)
    synchronize do
      if connected?(player)
        old_aid, new_aid = player.alliance_id_change
        leave(self.class.alliance_channel_name(old_aid), player) if old_aid
        join(self.class.alliance_channel_name(new_aid), player) if new_aid
      end
    end
  end

  # You should call this when Player#language changes.
  #
  # It depends on Player#language_change.
  def on_language_change(player)
    synchronize do
      if connected?(player)
        old_lang, new_lang = player.language_change
        leave(old_lang, player) unless old_lang == GLOBAL_CHANNEL_LANGUAGE
        join(new_lang, player) unless new_lang == GLOBAL_CHANNEL_LANGUAGE
      end
    end
  end

  def connected?(player)
    synchronize do
      joined?(player, GLOBAL_CHANNEL)
    end
  end

  # Is this _player_ joined to that _channel_?
  def joined?(player, channel)
    synchronize do
      check_channel(channel)
      @channels[channel].has?(player)
    end
  end

  # Send a _message_ to channel. Returns true if message was sent and false if
  # it was not.
  def channel_msg(channel_name, player, message)
    synchronize do
      # Return if this was a control message.
      @control.message(player, message) and return false
      @antiflood.message!(player.id)

      check_channel(channel_name)
      channel = @channels[channel_name]
      channel.message(player, message)
      true
    end
  end

  # Send a _message_ to +Player+ with ID _target_id_.
  def private_msg(player_id, target_id, message, created_at=nil)
    synchronize do
      if created_at.nil?
        if target_id == Chat::Control::SYSTEM_ID
          @control.message(Player.find(player_id), message)
          return false # Never process messages directed to system.
        end

        @antiflood.message!(player_id)
      end

      if dispatcher.player_connected?(target_id)
        params = {'pid' => player_id, 'msg' => message}

        # Retrieve player name from cache and send it to client with the
        # message if player is not connected right now. If message source
        # player is connected right now client will know his name because he
        # will be joined in 'galaxy' channel.
        params['name'] = player_name(player_id) \
          unless dispatcher.player_connected?(player_id)
        # Include timestamp if it is provided.
        params['stamp'] = created_at.as_json unless created_at.nil?

        dispatcher.transmit_to_players!(
          ChatController::PRIVATE_MESSAGE, params, target_id
        )
      else
        Chat::Message.store!(player_id, target_id, message)
      end

      true
    end
  end

  # Returns alliance channel name for alliance with this _alliance_id_.
  def self.alliance_channel_name(alliance_id)
    "alliance-#{alliance_id}"
  end

  private
  def dispatcher
    Celluloid::Actor[@dispatcher_actor_name]
  end

  # Retrieves player name by _player_id_ either from cache or from db (and
  # stores it in cache).
  def player_name(player_id)
    @names_cache[player_id] ||= Player.select("name").where(:id => player_id).
      c_select_value

    @names_cache[player_id]
  end

  def check_channel(channel_name)
    raise ArgumentError.new("Unknown channel #{channel_name}") \
      unless @channels.has_key?(channel_name)
  end

  # Invokes _method_ with _player_ for required channels. Forces to silence
  # events.
  def join_or_leave(player, method)
    send(method, GLOBAL_CHANNEL, player, false)
    send(method, player.language, player, false) \
      unless player.language == GLOBAL_CHANNEL_LANGUAGE
    send(method, 
      self.class.alliance_channel_name(player.alliance_id), player, false) \
      unless player.alliance_id.nil?
  end

  # Joins _player_ to channel.
  def join(channel_name, player, dispatch_to_self=true)
    @channels[channel_name] ||= Chat::Channel.new(
      channel_name, @dispatcher_actor_name
    )
    @channels[channel_name].join(player, dispatch_to_self)
    @channels_cache[player.id] ||= Set.new
    @channels_cache[player.id].add(channel_name)
  end

  # Makes _player_ leave the channel.
  def leave(channel_name, player, dispatch_to_self=true)
    check_channel(channel_name)
    @channels[channel_name].leave(player, dispatch_to_self)
    @channels_cache[player.id].delete(channel_name)
  end
end