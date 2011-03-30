# Chat hub that holds channels and directs all message moving in the galaxy.
class Chat::Hub
  # Global channel which everybody joins
  GLOBAL_CHANNEL = 'galaxy'
  # Language for global channel.
  GLOBAL_CHANNEL_LANGUAGE = 'en'

  def initialize(dispatcher)
    @dispatcher = dispatcher
    @channels = {}
    # Cache of player_id => channel_names pairs
    @channels_cache = {}
    @names_cache = {}
  end

  # Channels to which this _player_id_ is joined.
  def channels(player_id)
    (@channels_cache[player_id] || []).map { |name| @channels[name] }
  end

  # Registers player to this hub.
  def register(player)
    join_or_leave(player, :join)

    Chat::Message.retrieve!(player.id).each do |message|
      private_msg(message['source_id'], player.id, message['message'],
        message['created_at'])
    end
  end

  # Unregisters player from this hub.
  def unregister(player)
    join_or_leave(player, :leave)
  end

  # You should call this when Player#alliance_id changes.
  #
  # It depends on Player#alliance_id_change.
  def on_alliance_change(player)
    old_aid, new_aid = player.alliance_id_change
    leave(self.class.alliance_channel_name(old_aid), player) if old_aid
    join(self.class.alliance_channel_name(new_aid), player) if new_aid
  end

  # You should call this when Player#language changes.
  #
  # It depends on Player#language_change.
  def on_language_change(player)
    old_lang, new_lang = player.language_change
    leave(old_lang, player) unless old_lang == GLOBAL_CHANNEL_LANGUAGE
    join(new_lang, player) unless new_lang == GLOBAL_CHANNEL_LANGUAGE
  end

  # Is this _player_ joined to that _channel_?
  def joined?(player, channel)
    check_channel!(channel)
    @channels[channel].has?(player)
  end

  # Send a _message_ to channel.
  def channel_msg(channel_name, player, message)
    check_channel!(channel_name)
    channel = @channels[channel_name]
    channel.message(player, message)
  end

  # Send a _message_ to +Player+ with ID _target_id_.
  def private_msg(player_id, target_id, message, created_at=nil)
    if @dispatcher.connected?(target_id)
      params = {'pid' => player_id, 'msg' => message}

      # Retrieve player name from cache and send it to client with the
      # message if player is not connected right now. If message source
      # player is connected right now client will know his name because he
      # will be joined in 'galaxy' channel.
      params['name'] = player_name(player_id) \
        unless @dispatcher.connected?(player_id)
      # Include timestamp if it is provided.
      params['stamp'] = created_at.as_json unless created_at.nil?

      @dispatcher.transmit(
        {
          'action' => ChatController::PRIVATE_MESSAGE,
          'params' => params
        },
        target_id
      )
    else
      Chat::Message.store!(player_id, target_id, message)
    end
  end

  # Returns alliance channel name for alliance with this _alliance_id_.
  def self.alliance_channel_name(alliance_id)
    "alliance-#{alliance_id}"
  end

  private
  # Retrieves player name by _player_id_ either from cache or from db (and
  # stores it in cache).
  def player_name(player_id)
    @names_cache[player_id] ||= Player.connection.select_value(
      "SELECT name FROM `#{Player.table_name}` WHERE id=#{player_id.to_i}"
    )

    @names_cache[player_id]
  end

  def check_channel!(channel_name)
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
    @channels[channel_name] ||= Chat::Channel.new(channel_name, @dispatcher)
    @channels[channel_name].join(player, dispatch_to_self)
    @channels_cache[player.id] ||= Set.new
    @channels_cache[player.id].add(channel_name)
  end

  # Makes _player_ leave the channel.
  def leave(channel_name, player, dispatch_to_self=true)
    check_channel!(channel_name)
    @channels[channel_name].leave(player, dispatch_to_self)
    @channels_cache[player.id].delete(channel_name)
  end
end