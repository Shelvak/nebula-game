class Chat::Channel
  def initialize(name, dispatcher)
    @name = name
    @players = {}
    @dispatcher = dispatcher
  end

  def join(player)
    @players[player.id] = player
  end

  def leave(player)
    check_player!(player)
    @players.delete(player.id)
  end

  def message(player, message)
    check_player!(player)
    message = {
      'action' => ChatController::CHANNEL_MESSAGE,
      'params' => {
        'chan' => @name,
        'pid' => player.id,
        'msg' => message
      }
    }

    @players.each do |target|
      @dispatcher.transmit(message, target.id) unless player.id == target.id
    end
  end

  private
  # Check if _player_ is in channel.
  def check_player!(player)
    raise GameLogicError.new(
      "Player #{player} is not in channel #{@name}!") \
      unless @players.has_key?(player.id)
  end
end