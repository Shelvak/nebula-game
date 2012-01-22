class Chat::Channel
  # Channel name.
  attr_reader :name

  def initialize(name, dispatcher)
    @name = name
    # Hash of {player_id => Player} values.
    @players = {}
    @dispatcher = dispatcher
  end

  # Channel player list.
  def players
    @players.values
  end

  # Join _player_ to this channel.
  #
  # If _dispatch_to_self_ is false then event is not dispatched for
  # _player_. This is useful when using Chat::Hub#register.
  def join(player, dispatch_to_self=true)
    @players[player.id] = player
    
    player_join_msg = {'action' => ChatController::ACTION_JOIN, 'params' => {
      'channel' => @name, 'player' => player}}
    @players.each do |target_id, target|
      # Dispatch other players which are already joined to the channel to the
      # player which is joining.
      if dispatch_to_self && target_id != player.id
        existing_player_msg = {
          'action' => ChatController::ACTION_JOIN,
          'params' => {'channel' => @name, 'player' => target}
        }
        @dispatcher.push(existing_player_msg, player.id)
      end

      # Dispatch joining player to other players who are already in the channel.
      unless ! dispatch_to_self && player.id == target_id
        @dispatcher.push(player_join_msg, target_id)
      end
    end
  end

  # Make _player_ leave this channel.
  #
  # If _dispatch_to_self_ is false then event is not dispatched for
  # _player_. This is useful when using Chat::Hub#unregister.
  def leave(player, dispatch_to_self=true)
    check_player!(player)

    message = {'action' => ChatController::ACTION_LEAVE, 'params' => {
      'channel' => @name, 'player' => player}}
    @players.each do |target_id, target|
      @dispatcher.push(message, target_id) \
        unless ! dispatch_to_self && player.id == target_id
    end
    
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

    each_except(player.id) do |target|
      @dispatcher.transmit(message, target.id) unless player.id == target.id
    end
  end

  # Is this player joined to this channel?
  def has?(player)
    @players.has_key?(player.id)
  end

  private
  # Check if _player_ is in channel.
  def check_player!(player)
    raise ArgumentError.new(
      "Player #{player} is not in channel #{@name}!"
    ) unless has?(player)
  end

  # Yields each player except one with specified _player_id_.
  def each_except(excepted_player_id)
    @players.each do |player_id, player|
      yield player unless excepted_player_id == player_id
    end
  end
end