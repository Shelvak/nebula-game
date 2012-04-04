class Chat::Channel
  include MonitorMixin

  # Channel name.
  attr_reader :name

  def initialize(name, dispatcher_actor_name)
    typesig binding, String, Symbol
    super()

    @name = name
    # Hash of {player_id => Player} values.
    @players = {}
    @dispatcher_actor_name = dispatcher_actor_name
  end

  # Channel player list.
  def players
    synchronize do
      @players.values
    end
  end

  # Join _player_ to this channel.
  #
  # If _dispatch_to_self_ is false then event is not dispatched for
  # _player_. This is useful when using Chat::Hub#register.
  def join(player, dispatch_to_self=true)
    synchronize do
      @players[player.id] = player

      params = {'channel' => @name, 'player' => player}
      @players.each do |target_id, target|
        # Dispatch other players which are already joined to the channel to the
        # player which is joining.
        if dispatch_to_self && target_id != player.id
          dispatcher.push_to_player!(
            player.id, ChatController::ACTION_JOIN,
            {'channel' => @name, 'player' => target}
          )
        end

        # Dispatch joining player to other players who are already in the channel.
        unless ! dispatch_to_self && player.id == target_id
          dispatcher.push_to_player!(
            target_id, ChatController::ACTION_JOIN, params
          )
        end
      end
    end
  end

  # Make _player_ leave this channel.
  #
  # If _dispatch_to_self_ is false then event is not dispatched for
  # _player_. This is useful when using Chat::Hub#unregister.
  def leave(player, dispatch_to_self=true)
    synchronize do
      check_player(player)

      params = {'channel' => @name, 'player' => player}
      @players.each do |target_id, target|
        dispatcher.push_to_player!(
          target_id, ChatController::ACTION_LEAVE, params
        ) unless ! dispatch_to_self && player.id == target_id
      end

      @players.delete(player.id)
    end
  end

  def message(player, message)
    synchronize do
      check_player(player)
      params = {'chan' => @name, 'pid' => player.id, 'msg' => message}

      player_ids = @players.keys - [player.id]
      dispatcher.transmit_to_players!(
        ChatController::CHANNEL_MESSAGE, params, *player_ids
      )
    end
  end

  # Is this player joined to this channel?
  def has?(player)
    synchronize do
      @players.has_key?(player.id)
    end
  end

  private
  def dispatcher
    Celluloid::Actor[@dispatcher_actor_name]
  end

  # Check if _player_ is in channel.
  def check_player(player)
    raise ArgumentError.new(
      "Player #{player} is not in channel #{@name}!"
    ) unless has?(player)
  end
end