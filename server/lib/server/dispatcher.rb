class Dispatcher
  class BufferEntry < Struct.new(:message, :size)
    def initialize(message)
      size = Marshal.dump(message).size
      super(message, size)
    end
  end

  include NamedLogMessages
  include Celluloid

  TAG = 'dispatcher'

  # Maximum number of bytes in message buffer.
  MSG_BUFFER_MAX_SIZE = 512.kilobytes
  
  ### Connection throttling ###

  # Maximum number of allowed connections to this server.
  MAX_CONNECTIONS = 10000
  # Maximum number of time after which cleanup kills your connection if you
  # have no player.
  MAX_NO_AUTH_TIMEOUT = 15.seconds

  # Special key for message id. This is needed for client to do time
  # syncing.
  MESSAGE_ID_KEY = 'id'
  MESSAGE_SEQ_KEY = 'seq'
  MESSAGE_LAST_PROCESSED_SEQ_KEY = 'lpseq'
  MESSAGE_REPLY_TO_KEY = 'reply_to'
  # Disconnect action name.
  ACTION_DISCONNECT = 'players|disconnect'

  # Client has sent malformed message hash.
  DISCONNECT_NOT_A_MESSAGE = "not_a_message"
  # Other player has logged in as you.
  DISCONNECT_OTHER_LOGIN = "other_login"
  # Player was erased from server.
  DISCONNECT_PLAYER_ERASED = "player_erased"
  # Server has encountered an error.
  DISCONNECT_SERVER_ERROR = "server_error"
  # Client did not provide or provided bad last processed sequence number.
  DISCONNECT_NO_LPSEQ = "no_lpseq"
  # Message buffer was overflowed.
  DISCONNECT_MSG_BUFFER_OVERFLOW = "msg_buffer_overflow"
  # Reestablishing connection from other session.
  DISCONNECT_REESTABLISHING = "reestablishing"
  # Cannot reestablish connection.
  DISCONNECT_CANNOT_REESTABLISH = "cannot_reestablish"
  # Connection has been idle for too long.
  DISCONNECT_IDLE_CONNECTION = "idle_connection"

  S_KEY_SEQ = :seq
  S_KEY_CURRENT_SS_ID = :current_ss_id
  S_KEY_CURRENT_PLANET_ID = :current_planet_id

  # Message hash did not conform to message format.
  class NotAMessage < StandardError; end
  # Server cannot handle this message.
  class UnhandledMessage < StandardError; end
  class ClientDisconnected < StandardError; end

  # Initialize the dispatcher.
  def initialize
    @directors = DIRECTORS.each_with_object({}) do |(name, workers), hash|
      hash[name] = Threading::Director.new_link(name.to_s, workers)
    end

    # When which client has connected. {client => Time}
    @connection_time = {}
    @client_to_player = {}
    @player_id_to_client = {}
    # Session level storage to store data between controllers
    # {client => {key => value}}
    @storage = {}

    # {player_id => token}
    @reestablishment_tokens = {}
    # {player_id => LinkedList[String]}
    @message_buffers = Hash.new do |hash, player_id|
      hash[player_id] = Java::java.util.LinkedList.new
    end
  end

  # Override inspect from celluloid because that gets us infinite recursion
  # error while inspecting directors.
  def inspect
    "<Dispatcher clients=#{@storage.size} players=#{@client_to_player.size
      } directors=#{@directors.keys.join(",")}>"
  end

  def to_s(client=nil)
    client.nil? ? TAG : "#{TAG}-#{client}"
  end

  # Returns Hash of {director_name => enqueued_tasks}.
  def director_stats
    @directors.map do |name, director|
      [name, director.future(:enqueued_tasks)]
    end.each_with_object({}) do |(name, future), hash|
      hash[name] = future.value
    end
  end

  # Register new client to dispatcher.
  def register(client)
    info "Registering.", to_s(client)
    cleanup_idle_connections!
    @storage[client] = {}
    @connection_time[client] = Time.now
  end

  # Unregister client from dispatcher.
  def unregister(client)
    # Someone unregistered us before, probably from #disconnect
    return unless @storage.has_key?(client)
    tag = to_s(client)
    player = resolve_player(client)

    info "Unregistering: #{player ? player.to_s : "not a player"}.", tag

    unless player.nil?
      dispatch_task(
        Scope.world, PlayerUnregisterTask.player(tag, player)
      )
      # There is no point of notifying about leaves if server is shutdowning.
      dispatch_task(Scope.chat, PlayerUnregisterTask.chat(tag, player)) \
        unless App.server_shutdowning?

      # Clean up containers.
      @reestablishment_tokens.delete(player.id)
      @message_buffers.delete(player.id)
      @player_id_to_client.delete(player.id)
    end

    @client_to_player.delete client
    @storage.delete client
    @connection_time.delete client
  end

  def reestablish_connection(client, player_id, last_processed_seq, token)
    raise_to_abort do
      typesig binding, ServerActor::Client, Fixnum, Fixnum, String
    end

    data = "player_id:#{player_id} last_processed_seq:#{last_processed_seq
      } token:#{token}"

    stored_token = @reestablishment_tokens[player_id]
    if token == stored_token
      old_client = @player_id_to_client[player_id]
      player = @client_to_player[old_client]

      info "Reestablishing #{player} with given data (#{data})", to_s(client)
      stored_message_buffer = @message_buffers[player_id]

      deliver_buffer(client, player_id, last_processed_seq)
      storage = @storage[old_client]

      # Remove old client to player association to prevent unregistering from
      # chat and etc.
      @client_to_player.delete old_client
      @player_id_to_client.delete player_id

      # Disconnect old client.
      disconnect(old_client, DISCONNECT_REESTABLISHING)
      # Associate new player.
      set_player(client, player)

      # Reassign stored values.
      @reestablishment_tokens[player_id] = stored_token
      @message_buffers[player_id] = stored_message_buffer
      @storage[client] = storage
    else
      info "Cannot reestablish player #{player_id} with given data (#{data
        }): bad token", to_s(client)
      disconnect(client, DISCONNECT_CANNOT_REESTABLISH)
    end
  end

  # Returns number of logged in players.
  def logged_in_count; @client_to_player.size; end

  # Change current player associated with current player id. Also register
  # this player to chat.
  def set_player(client, player)
    raise_to_abort { typesig binding, ServerActor::Client, Player }
    tag = to_s(client)

    debug "Registering #{client} as #{player}.", tag

    if player_connected?(player.id)
      old_client = @player_id_to_client[player.id]
      disconnect(old_client, DISCONNECT_OTHER_LOGIN)
    end

    @client_to_player[client] = player
    @player_id_to_client[player.id] = client
  end

  # Generate connection reestablishment token, associate it with Player and
  # return it.
  def generate_reestablishment_token(player)
    raise_to_abort { typesig binding, Player }
    token = (0...100).map { |i| rand(4294967296).to_s(36) }.join("")
    @reestablishment_tokens[player.id] = token
    token
  end

  # Update player entry if player is connected.
  def update_player(player)
    client = @player_id_to_client[player.id]
    if client
      @client_to_player[client] = player
    else
      abort RuntimeError.new(
        "Cannot update player #{player} which is not registered!"
      )
    end
  end

  # Receive message hash from _client_.
  def receive_message(client, message_hash)
    exclusive do
      log_tag = to_s(client)

      cleanup_buffer(client, message_hash[MESSAGE_LAST_PROCESSED_SEQ_KEY])

      debug "Received message hash: #{message_hash.inspect}", log_tag

      message = message_object(client, message_hash)
      LOGGER.block(
        "Received message: #{message}",
        component: log_tag, level: :debug
      ) { process_message(message) }
    end
  rescue NotAMessage => e
    info "Cannot process #{message_hash} - #{e.class}: #{e.message}",
      to_s(client)
    disconnect(client, DISCONNECT_NOT_A_MESSAGE)
  rescue UnhandledMessage => e
    info "Cannot process #{message} - #{e.class}: #{e.message}", to_s(client)
    confirm_receive(message, e)
  end

  def callback(callback)
    exclusive do
      raise_to_abort { typesig binding, Callback }
      debug "Received: #{callback}"

      klass = callback.klass
      method_name = callback.type

      scope_const = "#{method_name.upcase}_SCOPE"
      callback_method = "#{method_name}_callback"

      unless klass.const_defined?(scope_const)
        error "#{klass} is missing scope resolver: #{klass}::#{scope_const}"
        return
      end

      scope = klass.const_get(scope_const)
      task = Dispatcher::CallbackTask.create(klass, callback_method, callback)
      dispatch_task(scope, task)
    end
  end

  # Confirm client of _message_ receiving. Set error to inform client
  # that his last action has failed.
  def confirm_receive(message, error=nil)
    raise_to_abort { typesig binding, Message, [NilClass, Exception] }

    client = client_from_message(message)
    confirmation = {
      MESSAGE_REPLY_TO_KEY => message.id,
      MESSAGE_SEQ_KEY => next_client_seq(client)
    }
    if error
      confirmation['failed'] = true
      confirmation['error'] = {
        'type' => error.class.to_s,
        'message' => error.message
      }
      debug "Confirming #{message} with error.", to_s(client)
    else
      debug "Confirming successful #{message}.", to_s(client)
    end

    transmit_to_client(client, confirmation)
  end

  # Disconnect client. Send message and close connection.
  def disconnect(client_or_id, reason=nil)
    client = client_or_id.is_a?(Fixnum) \
      ? @player_id_to_client[client_or_id] : client_or_id
    return if client.nil?

    transmit_to_client(client, {
      "action" => ACTION_DISCONNECT,
      "params" => {"reason" => reason}
    })
    unregister client
    #Actor[:server].disconnect!(client)
    EventMachine.next_tick do
      client.em_connection.close_connection_after_writing
    end
  end

  # Responds to received/pushed message.
  def respond(message, params)
    raise_to_abort { typesig binding, Message, Hash }

    client = client_from_message(message)
    message_hash = {
      # Pushed messages have message sequence number, regular messages don't.
      # Generate one for them instead. See #message_object for more info.
      MESSAGE_SEQ_KEY => message.seq || next_client_seq(client),
      "action" => message.full_action,
      "params" => params
    }

    transmit_to_client(client, message_hash)
  end

  # Transmits message to given players ids.
  def transmit_to_players(action, params={}, *player_ids)
    raise_to_abort { typesig binding, String, Hash, Array }

    clients = player_ids.map do |player_id|
      @player_id_to_client[player_id]
    end.compact

    transmit_to_clients(action, params, *clients)
  end

  # Transmit message to clients.
  def transmit_to_clients(action, params={}, *clients)
    raise_to_abort { typesig binding, String, Hash, Array }

    message_hash = {"action" => action, "params" => params}

    clients.each do |client|
      transmit_to_client(
        client,
        message_hash.merge(MESSAGE_SEQ_KEY => next_client_seq(client))
      )
    end
  end

  # Thread safe storage getter.
  def storage_get(message, key)
    client = client_from_message(message)

    abort ClientDisconnected.new(
      "#{client} has already disconnected, no storage available!"
    ) unless client_connected?(client)
    client_storage = @storage[client]
    client_storage[key]
  end
  # Thread safe storage setter.
  def storage_set(message, key, value)
    client = client_from_message(message)

    return unless client_connected?(client)
    client_storage = @storage[client]
    client_storage[key] = value
    nil
  end

  def atomic(atomizer)
    atomizer.implode(self)
  end
  
  # Pushes message to all logged in players.
  def push_to_logged_in(action, params={}, filters=nil)
    @client_to_player.each do |client, _|
      push(client, action, params, filters)
    end
  end

  # Pushes message to player if he is connected.
  #
  # @see #push
  def push_to_player(player_id, action, params={}, filters=nil)
    raise_to_abort do
      typesig binding, Fixnum, String, Hash,
        [NilClass, Array, Dispatcher::PushFilter]
    end

    client = @player_id_to_client[player_id]
    if client.nil?
      debug "Push to player #{player_id} filtered: not connected."
      return
    end

    push(client, action, params, filters)
  end

  # Push message to client if he's connected.
  #
  # Filters can be:
  # - nil: no filter
  # - Dispatcher::PushFilter[]: if one of them matches, message is passed
  # through.
  #
  def push(client, action, params, filters=nil)
    raise_to_abort do
      typesig binding, ServerActor::Client, String, Hash,
        [NilClass, Array, Dispatcher::PushFilter]
    end

    log = "action #{action.inspect} with params #{params.inspect} and filters #{
      filters.inspect}."

    unless client_connected?(client)
      debug "Pushing #{log} filtered: client not connected"
      return
    end

    unless push_filters_match?(client, filters)
      debug "Pushing #{log} filtered: push filters do not match."
      return
    end

    debug "Pushing #{log}.", to_s(client)
    message = message_object(
      client,
      {"action" => action, "params" => params},
      true
    )
    process_message(message)
  end

  # Is _client_ connected?
  def client_connected?(client)
    @storage.has_key?(client)
  end

  # Is player with _player_id_ connected?
  def player_connected?(player_id)
    @player_id_to_client.has_key?(player_id)
  end

  # Resolves _what_ to +Player+ model if it is connected.
  #
  # _what_ can be +ServerActor::Client+ or +Fixnum+ (player id)
  def resolve_player(what)
    case what
    when ServerActor::Client
      @client_to_player[what]
    when Fixnum
      client = @player_id_to_client[what]
      return if client.nil?
      resolve_player(client)
    else
      abort ArgumentError.new("Unknown parameter type #{what.inspect}!")
    end
  end

private

  # Solar system ID which is currently viewed by client.
  def current_ss_id(client); @storage[client][S_KEY_CURRENT_SS_ID]; end
  # SsObject ID which is currently viewed by client.
  def current_planet_id(client)
    @storage[client][S_KEY_CURRENT_PLANET_ID]
  end

  def initialize_controllers!
    return unless @controllers.nil?

    LOGGER.block("Initializing controllers") do
      @controllers = {}
      Dir.glob(
        File.join(ROOT_DIR, 'lib', 'app', 'controllers', '*.rb')
      ).each do |file|
        file_name = File.basename(file).sub(/\.rb$/, '')
        class_name = file_name.camelcase

        debug "Registering controller: #{class_name}"
        controller_name = file_name.sub(/_controller$/, '')
        @controllers[controller_name] = class_name.constantize
      end

      info "Registered controllers: #{@controllers.keys.sort}"
    end
  end

  def process_message(message)
    log_str = to_s(message.client)

    options_const = "#{message.action.upcase}_OPTIONS"
    scope_const = "#{message.action.upcase}_SCOPE"
    action_method = "#{message.action}_action"

    initialize_controllers!
    controller_class = @controllers[message.controller_name]
    raise UnhandledMessage.new(
      "No such controller: #{message}"
    ) if controller_class.nil?
    raise UnhandledMessage.new(
      "No such action: #{message}"
    ) unless controller_class.respond_to?(action_method)

    # Check options.
    unless controller_class.const_defined?(options_const)
      error_str = "#{message.full_action} is missing options constant!"
      error error_str, log_str
      raise UnhandledMessage.new(error_str)
    end
    controller_class.const_get(options_const).check!(message)

    unless controller_class.const_defined?(scope_const)
      error_str = "#{message.full_action} is missing scope resolver method!"
      error error_str, log_str
      raise UnhandledMessage.new(error_str)
    end

    scope = controller_class.const_get(scope_const)
    task = ControllerTask.create(controller_class, action_method, message)
    dispatch_task(scope, task)
  rescue GenericController::ParamOpts::BadParams, UnhandledMessage => e
    if message.pushed?
      error "Cannot process #{message} - #{e.class}: #{e.message}", log_str
      disconnect(message.client, DISCONNECT_SERVER_ERROR)
    else
      info "Cannot process #{message} - #{e.class}: #{e.message}", log_str
      confirm_receive(message, e)
    end
  end

  # Dispatches a +Threading::Director::Task+ to appropriate
  # +Threading::Director+ according to its +Dispatcher::Scope+.
  def dispatch_task(scope, task)
    typesig binding, Scope, Threading::Director::Task

    name = scope.name

    director = @directors[name]
    raise "Missing director #{name.inspect}!" if director.nil?

    debug "Dispatching to #{name} director: #{task}"
    director.work!(task)
  end

  # Check if one of the given push filters match for current client.
  # TODO: spec
  def push_filters_match?(client, filters)
    return true if filters.nil?

    filters = filters.is_a?(Array) ? filters : [filters]
    filters.each do |filter|
      return true if filter.nil?

      case filter.scope
      when PushFilter::SOLAR_SYSTEM
        current = current_ss_id(client)
        return true if current == filter.id
        debug "Push filtered: wanted SS #{filter.id}, had #{current.inspect}",
          to_s(client)
      when PushFilter::SS_OBJECT
        current = current_planet_id(client)
        return true if current == filter.id
        debug "Push filtered: wanted SSO #{filter.id}, had #{current.inspect}",
          to_s(client)
      else
        raise ArgumentError.new("Unknown filter scope: #{filter.scope.inspect}")
      end
    end

    false
  end

  # Assign client_id and player to _message_ and log assignation.
  def message_object(client, message, pushed=false)
    Dispatcher::Message.new(
      message['id'],
      # Only assign message sequence number if it was pushed, because pushed
      # messages are dispatched to different threads and can come back out of
      # order. Sequencing helps client to get around that.
      pushed ? next_client_seq(client) : nil,
      message['action'] || "",
      message['params'] || {},
      client,
      resolve_player(client),
      pushed
    )
  end

  def next_client_seq(client)
    # Doesn't matter what we return if client is not connected.
    return unless client_connected?(client)

    @storage[client][S_KEY_SEQ] ||= -1 # Start sequences from 0
    value = @storage[client][S_KEY_SEQ] += 1
    debug "Returning sequence number: #{value}", to_s(client)
    value
  end

  # Return new pseudo-unique ID for message.
  def next_message_id
    "%d" % (Time.now.to_f * 1000)
  end

  # Set message id and push it into outgoing messages stack for given IO.
  def transmit_to_client(client, message_hash)
    # Message ID may be already stored if we are replaying old messages on
    # connection reestablishment.
    message_hash[MESSAGE_ID_KEY] ||= next_message_id

    # Write data to socket.
    EventMachine.next_tick { client.em_connection.write(message_hash) }

    # Store message for connection reestablishment.
    player = @client_to_player[client]
    @message_buffers[player.id].add BufferEntry.new(message_hash) \
      unless player.nil?

    #Actor[:server].write!(client, message_hash)
  end

  # Clean up message buffers from processed messages.
  def cleanup_buffer(client, last_processed_seq)
    player = @client_to_player[client]
    # No lpseq is needed or possible for non-player clients.
    return if player.nil?

    # Authenticated players are required to provide lpseq.
    disconnect(client, DISCONNECT_NO_LPSEQ) \
      unless last_processed_seq.is_a?(Fixnum)

    tag = self.to_s(client)
    buffer = @message_buffers[player.id]
    debug "Preparing to clean #{player} buffer with #{buffer.size} messages.",
      tag

    # Clean up buffer from processed messages.
    cleaned = 0
    while ! (entry = buffer.peek).nil? &&
        entry.message[MESSAGE_SEQ_KEY] <= last_processed_seq
      cleaned += 1
      buffer.removeFirst
    end
    debug "#{cleaned} messages cleaned from buffer for #{player}", tag

    # Calculate total size.
    total_size = buffer.inject(0) { |sum, entry| sum + entry.size }
    debug "Current buffer for #{player}: msgsize:#{buffer.size} bytesize:#{
      total_size}", tag

    # Disconnect client if buffer is still too large.
    if total_size > MSG_BUFFER_MAX_SIZE
      info "Disconnecting because #{player} buffer (msgsize:#{buffer.size
        } bytesize:#{total_size}) is too big!", tag
      disconnect(client, DISCONNECT_MSG_BUFFER_OVERFLOW)
    end
  end

  # Deliver missed messages to client.
  def deliver_buffer(client, player_id, last_processed_seq)
    debug "Delivering stored message buffer to player #{player_id
      }, last processed seq: #{last_processed_seq}", to_s(client)

    buffer = @message_buffers[player_id]
    buffer.each do |entry|
      transmit_to_client(client, entry.message) \
        if entry.message[MESSAGE_SEQ_KEY] > last_processed_seq
    end
  end

  # Resolve current +Client+ from +Message+. Client might change if player had
  # its connection dropped and is reestablishing connection.
  def client_from_message(message)
    # Lets try to find our socket from player -> client hash.
    client = message.player.nil? ? nil : @player_id_to_client[message.player.id]
    # If it is not found, just use original socket that message was received
    # from.
    client || message.client
  end

  # Clean idle connections up to ensure that we can open new connections.
  def cleanup_idle_connections!
    return unless @connection_time.size > MAX_CONNECTIONS

    info "Cleaning up idle connections, because we have #{@connection_time.size
      } connections, which is more than max #{MAX_CONNECTIONS}."
    now = Time.now
    cleaned_up = 0
    @connection_time.each do |client, time|
      next unless @client_to_player[client].nil?

      if now - time >= MAX_NO_AUTH_TIMEOUT
        disconnect(client, DISCONNECT_IDLE_CONNECTION)
        cleaned_up += 1
      end
    end

    if @connection_time.size > MAX_CONNECTIONS
      info "Cleaned up #{cleaned_up} connections, but #{@connection_time.size
        } > #{MAX_CONNECTIONS} connections still left. Entering phase 2."

      cleaned_up = 0
      @connection_time.sort do |(client1, time1), (client2, time2)|
        player1 = @client_to_player[client1]
        player2 = @client_to_player[client2]

        # Both clients have no player - longer conn time first.
        if player1.nil? && player2.nil? then time1 <=> time2
        # Client 1: no player, client 2: player - client 1 first.
        elsif player1.nil? && ! player2.nil? then -1
        # Client 1: player, client 2: no player - client 2 first.
        elsif player2.nil? && ! player1.nil? then 1
        # Client 1: trial, client 2: trial - longer conn time first.
        elsif player1.trial? && player2.trial? then time1 <=> time2
        # Client 1: trial, client 2: non trial - first player first.
        elsif player1.trial? && ! player2.trial? then -1
        # Client 1: non trial, client 2: trial - second player first.
        elsif player2.trial? && ! player1.trial? then 1
        # Both clients non-trial - longer conn time first.
        else time1 <=> time2; end
      end.each do |client, time|
        if @client_to_player[client].nil?
          disconnect(client, DISCONNECT_IDLE_CONNECTION)
          cleaned_up += 1
        end

        break unless @connection_time.size > MAX_CONNECTIONS
      end
      info "Phase 2: Cleaned up #{cleaned_up} connections, #{
        @connection_time.size} connections left."
    else
      info "Cleaned up #{cleaned_up} connections, #{@connection_time.size
        } connections left."
    end
  end
end

# Preload some essentials.
require File.dirname(__FILE__) + '/dispatcher/scope'
