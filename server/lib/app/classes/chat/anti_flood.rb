class Chat::AntiFlood
  def initialize(dispatcher)
    @dispatcher = dispatcher

    # {player_id => Fixnum}
    @silence_counters = Hash.new(0)
    # {player_id => Time}
    @silence_until = {}
    # {player_id => LinkedList[Time, Time, ...]}
    @messages = Hash.new do |hash, player_id|
      hash[player_id] = Java::java.util.LinkedList.new
    end
  end

  # Registers message which arrived at _timestamp_ (Time.now is used if
  # _timestamp_ is nil).
  #
  # Checks if user has been silenced. If so - raises +GameLogicError+.
  def message!(player_id, timestamp=nil)
    check_if_silenced!(player_id)
    message(player_id, timestamp || Time.now)
  end

  private

  def message(player_id, timestamp)
    timestamp = timestamp.to_f

    list = @messages[player_id]
    list.add timestamp
    if list.size > Cfg.chat_antiflood_messages
      list.remove_first
      first = list.first

      silence(player_id) \
        if timestamp - first < Cfg.chat_antiflood_period
    end
  end

  def silence(player_id)
    counter = @silence_counters[player_id] += 1
    silence_period = Cfg.chat_antiflood_silence_for(counter)
    silence_until = @silence_until[player_id] = silence_period.from_now

    @dispatcher.push_to_player(
      player_id, ChatController::ACTION_SILENCE, {'until' => silence_until}
    )
  end

  def check_if_silenced!(player_id)
    silenced_until = @silence_until[player_id]
    raise GameLogicError.new(
      "Cannot send message, because player #{player_id} is silenced until #{
      silenced_until}!"
    ) unless silenced_until.nil? || silenced_until < Time.now
  end
end