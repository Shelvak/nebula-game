class ChatController < GenericController
  # Sends channels and their participants for the player.
  # 
  # Invocation: by server
  #
  # Response:
  # - channels (Hash): Hash of {channel_name => player_ids} pairs where
  # _player_ids_ is +Array+ of +Fixnum+.
  # - players (Hash): Hash of {player_id => player_name} pairs.
  #
  ACTION_INDEX = 'chat|index'

  INDEX_OPTIONS = logged_in + only_push
  def self.index_scope(message); scope.chat; end
  def self.index_action(m)
    hub = Chat::Pool.instance.hub_for(m.player)
    
    channels = hub.channels(m.player.id).map_into_hash do |channel|
      [channel.name, channel.players.map(&:id)]
    end

    players = hub.players.map_into_hash do |player|
      [player.id, player.name]
    end

    respond m, :channels => channels, :players => players
    hub.send_stored!(m.player)
  end

  # Channel message.
  #
  # Invocation: by client.
  #
  # Parameters:
  # - chan (String): channel name
  # - msg (String): message (up to 255 symbols)
  #
  # Response: None
  #
  # Invocation: by server.
  #
  # Response:
  # - chan (String): channel name
  # - msg (String): message (up to 255 symbols)
  # - pid (Fixnum): player ID that has sent the message
  #
  CHANNEL_MESSAGE = 'chat|c'

  C_OPTIONS = logged_in + required(:chan => String, :msg => String)
  def self.c_scope(m); scope.chat; end
  def self.c_action(m)
    hub = Chat::Pool.instance.hub_for(m.player)
    hub.channel_msg(m.params['chan'], m.player, m.params['msg'])
  end

  # Private message.
  #
  # Invocation: by client
  #
  # Parameters:
  # - pid (Fixnum): target +Player+ ID.
  # - msg (String): message (up to 255 symbols)
  #
  # Response: None
  #
  # Invocation: by server
  #
  # Response:
  # - pid (Fixnum): source +Player+ ID.
  # - msg (String): message (up to 255 symbols)
  # - name (String): name of the +Player+. (only sent if player is not logged in)
  # - stamp (Time): time when the message was created. (only sent if message
  # was stored in DB)
  #
  PRIVATE_MESSAGE = 'chat|m'

  M_OPTIONS = logged_in + required(:pid => Fixnum, :msg => String)
  def self.m_scope(m); scope.chat; end
  def self.m_action(m)
    hub = Chat::Pool.instance.hub_for(m.player)
    hub.private_msg(m.player.id, m.params['pid'], m.params['msg'])
  end

  # Notifies client about another player joining a channel.
  #
  # This can be pushed for same player too if it is issued as a part of some
  # third part action like changing the alliance. In that case you should
  # open a new tab in client for this channel because client is now joined
  # to that channel.
  #
  # Invocation: by server
  #
  # Response:
  # - chan (String): channel name
  # - pid (Fixnum): +Player+ id
  # - name (String): +Player+ name
  #
  ACTION_JOIN = 'chat|join'

  JOIN_OPTIONS = logged_in + only_push +
    required(:channel => String, :player => Player)
  def self.join_scope(m); scope.chat; end
  def self.join_action(m)
    respond m,
      :chan => m.params['channel'],
      :pid  => m.params['player'].id,
      :name => m.params['player'].name
  end

  # Notifies client about another player leaving a channel.
  #
  # See chat|join for notes about cases when this can be sent for the same
  # player.
  #
  # Invocation: by server
  #
  # Response:
  # - chan (String): channel name
  # - pid (Fixnum): +Player+ id
  #
  ACTION_LEAVE = 'chat|leave'

  LEAVE_OPTIONS = logged_in + only_push +
    required(:channel => String, :player => Player)
  def self.leave_scope(m); scope.chat; end
  def self.leave_action(m)
    respond m, :chan => m.params['channel'], :pid => m.params['player'].id
  end

  # Notifies client that player was silenced.
  #
  # Invocation: by server
  #
  # Response:
  # - until (Time): time when silence expires
  #
  ACTION_SILENCE = 'chat|silence'

  SILENCE_OPTIONS = logged_in + only_push + required(:until => Time)
  def self.silence_scope(m); scope.chat; end
  def self.silence_action(m)
    respond m, :until => m.params['until']
  end
end