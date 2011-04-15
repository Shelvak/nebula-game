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
  def action_index
    only_push!

    hub = Chat::Pool.instance.hub_for(player)
    
    channels = hub.channels(player.id).map_into_hash do |channel|
      [channel.name, channel.players.map(&:id)]
    end

    players = hub.players.map_into_hash do |player|
      [player.id, player.name]
    end

    respond :channels => channels, :players => players
  end

  # Action name used for channel message.
  CHANNEL_MESSAGE = 'chat|c'
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
  def action_c
    param_options :required => %w{chan msg}

    hub = Chat::Pool.instance.hub_for(player)
    hub.channel_msg(params['chan'], player, params['msg'])
  end

  # Action name used for private message.
  PRIVATE_MESSAGE = 'chat|m'
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
  # - stamp (Time): time when the message was created. (only sent if message was stored in DB)
  #
  def action_m
    param_options :required => %w{pid msg}

    hub = Chat::Pool.instance.hub_for(player)
    hub.private_msg(player.id, params['pid'], params['msg'])
  end

  ACTION_JOIN = 'chat|join'
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
  def action_join
    only_push!
    param_options :required => %w{channel player}

    respond :chan => params['channel'], :pid => params['player'].id,
      :name => params['player'].name
  end

  ACTION_LEAVE = 'chat|leave'
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
  def action_leave
    only_push!
    param_options :required => %w{channel player}

    respond :chan => params['channel'], :pid => params['player'].id
  end
end