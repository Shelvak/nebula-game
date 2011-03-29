class ChatController < GenericController
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
  # Parameters:
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
  # Parameters:
  # - pid (Fixnum): source +Player+ ID.
  # - msg (String): message (up to 255 symbols)
  # - name (String): name of the +Player+. (only sent if player is not logged in)
  #
  def action_m
    param_options :required => %w{pid msg}

    hub = Chat::Pool.instance.hub_for(player)
    hub.private_msg(player, params['pid'], params['msg'])
  end
end