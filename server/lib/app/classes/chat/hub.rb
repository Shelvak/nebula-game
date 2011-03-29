# Chat hub that holds channels and directs all message moving in the galaxy.
class Chat::Hub
  def initialize(dispatcher)
    @dispatcher = dispatcher
    @channels = {}
  end

  # Joins player to channel.
  def join(channel_name, player)
    @channels[channel_name] ||= Chat::Channel.new(channel_name, @dispatcher)
    @channels[channel_name].join(player)
  end

  def leave(channel_name, player)
    raise GameLogicError.new("Unknown channel #{channel_name}") \
      unless @channels.has_key?(channel_name)

    @channels[channel_name].leave(player)
  end

  # Send a _message_ to channel.
  def channel_msg(channel_name, player, message)
    raise GameLogicError.new("Unknown channel #{channel_name}") \
      unless @channels.has_key?(channel_name)

    channel = @channels[channel_name]
    channel.message(player, message)
  end

  # Send a _message_ to +Player+ with ID _target_id_.
  def private_msg(player_id, target_id, message)
    if @dispatcher.connected?(target_id)
      @dispatcher.transmit(
        {
          'action' => ChatController::PRIVATE_MESSAGE,
          'params' => {'pid' => player_id, 'msg' => message}
        },
        target_id
      )
    else
      Chat::Message.store!(player_id, target_id, message)
    end
  end
end