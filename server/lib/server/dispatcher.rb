class Dispatcher
  include NamedLogMessages
  include Celluloid

  TAG = 'dispatcher'
  
  # Special key for message id. This is needed for client to do time
  # syncing.
  MESSAGE_ID_KEY = 'id'
  MESSAGE_SEQ_KEY = 'seq'
  MESSAGE_REPLY_TO_KEY = 'reply_to'
  # Disconnect action name.
  ACTION_DISCONNECT = 'players|disconnect'

  # Other player has logged in as you.
  DISCONNECT_OTHER_LOGIN = "other_login"
  # Player was erased from server.
  DISCONNECT_PLAYER_ERASED = "player_erased"
  # Server has encountered an error.
  DISCONNECT_SERVER_ERROR = "server_error"

  S_KEY_SEQ = :seq
  S_KEY_CURRENT_SS_ID = :current_ss_id
  S_KEY_CURRENT_PLANET_ID = :current_planet_id
  
  class UnhandledMessage < StandardError; end
  class ClientDisconnected < StandardError; end

  # Initialize the dispatcher.
  def initialize
    @directors = {
      :chat => Threading::Director.new_link("chat", WORKERS_CHAT),
      :world => Threading::Director.new_link("world", WORKERS_WORLD),
    }

    @client_to_player = {}
    @player_id_to_client = {}
    # Session level storage to store data between controllers
    @storage = {}
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

  # Register new client to dispatcher.
  def register(client)
    info "Registering.", to_s(client)
    @storage[client] = {}
  end

  # Unregister client from dispatcher.
  def unregister(client)
    # Someone unregistered us before, probably from #disconnect
    return unless @storage.has_key?(client)
    tag = to_s(client)

    info "Unregistering.", tag

    player = resolve_player(client)
    # This is safe because it is in same thread.
    unless player.nil?
      dispatch_task(
        Scope.world, PlayerUnregisterTask.player(tag, player)
      )
      # There is no point of notifying about leaves if server is shutdowning.
      dispatch_task(Scope.chat, PlayerUnregisterTask.chat(tag, player)) \
        unless App.server_shutdowning?
    end

    # Clean up containers.
    player = @client_to_player[client]
    @player_id_to_client.delete(player.id) unless player.nil?
    @client_to_player.delete client
    @storage.delete client
  end

  # Returns number of logged in players.
  def logged_in_count; @client_to_player.size; end

  # Change current player associated with current player id. Also register
  # this player to chat.
  def set_player(client, player)
    typesig binding, ServerActor::Client, Player
    tag = to_s(client)

    debug "Registering #{client} as #{player}.", tag

    if player_connected?(player.id)
      old_client = @player_id_to_client[player.id]
      disconnect(old_client, DISCONNECT_OTHER_LOGIN)
    end

    @client_to_player[client] = player
    @player_id_to_client[player.id] = client
  end

  # Update player entry if player is connected.
  def update_player(player)
    client = @player_id_to_client[player.id]
    if client
      @client_to_player[client] = player
    else
      abort "Cannot update player #{player} which is not registered!"
    end
  end

  # Receive message hash from _client_.
  def receive_message(client, message_hash)
    exclusive do
      log_tag = to_s(client)

      debug "Received message hash: #{message_hash.inspect}", log_tag

      message = message_object(client, message_hash)
      LOGGER.block(
        "Received message: #{message}",
        :component => log_tag
      ) { process_message(message) }
    end
  rescue UnhandledMessage => e
    info "Cannot process #{message} - #{e.class}: #{e.message}", to_s(client)
    confirm_receive(message, e)
  end

  def callback(callback)
    exclusive do
      typesig binding, Callback
      info "Received: #{callback}"

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
    typesig binding, Message, [NilClass, Exception]

    confirmation = {
      MESSAGE_REPLY_TO_KEY => message.id,
      MESSAGE_SEQ_KEY => next_client_seq(message.client)
    }
    if error
      confirmation['failed'] = true
      confirmation['error'] = {
        'type' => error.class.to_s,
        'message' => error.message
      }
      info "Confirming #{message} with error.", to_s(message.client)
    else
      info "Confirming successful #{message}.", to_s(message.client)
    end

    transmit_to_client(message.client, confirmation)
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
    Actor[:server].disconnect!(client)
  end

  # Responds to received/pushed message.
  def respond(message, params)
    typesig binding, Message, Hash

    message_hash = {
      # Pushed messages have message sequence number, regular messages don't.
      # Generate one for them instead. See #message_object for more info.
      MESSAGE_SEQ_KEY => message.seq || next_client_seq(message.client),
      "action" => message.full_action,
      "params" => params
    }

    transmit_to_client(message.client, message_hash)
  end

  # Transmits message to given players ids.
  def transmit_to_players(action, params={}, *player_ids)
    typesig binding, String, Hash, Array

    clients = player_ids.map do |player_id|
      @player_id_to_client[player_id]
    end.compact

    transmit_to_clients(action, params, *clients)
  end

  # Transmit message to clients.
  def transmit_to_clients(action, params={}, *clients)
    typesig binding, String, Hash, Array

    message_hash = {"action" => action, "params" => params}

    clients.each do |client|
      transmit_to_client(client, message_hash)
    end
  end

  # Thread safe storage getter.
  def storage_get(client, key)
    abort ClientDisconnected.new(
      "#{client} has already disconnected, no storage available!"
    ) unless client_connected?(client)
    client_storage = @storage[client]
    client_storage[key]
  end
  # Thread safe storage setter.
  def storage_set(client, key, value)
    abort ClientDisconnected.new(
      "#{client} has already disconnected, no storage available!"
    ) unless client_connected?(client)
    client_storage = @storage[client]
    client_storage[key] = value
  end

  # Solar system ID which is currently viewed by client.
  def current_ss_id(client); @storage[client][S_KEY_CURRENT_SS_ID]; end
  # SsObject ID which is currently viewed by client.
  def current_planet_id(client)
    @storage[client][S_KEY_CURRENT_PLANET_ID]
  end

  def atomic(atomizer)
    atomizer.implode(self)
  end
  
  # Pushes message to all logged in players.
  def push_to_logged_in(action, params={})
    @client_to_player.each do |client, _|
      push(client, action, params)
    end
  end

  # Pushes message to player if he is connected.
  #
  # @see #push
  def push_to_player(player_id, action, params={}, filters=nil)
    typesig binding, Fixnum, String, Hash,
      [NilClass, Array, Dispatcher::PushFilter]

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
    typesig binding, ServerActor::Client, String, Hash,
      [NilClass, Array, Dispatcher::PushFilter]

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

  # Resolves _id_ to +Player+ model if it is connected.
  def resolve_player(client)
    @client_to_player[client]
  end

  private

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

    info "Dispatching to #{name} director: #{task}"
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
    message_hash[MESSAGE_ID_KEY] = next_message_id
    Actor[:server].write!(client, message_hash)
  end
end

# Preload some essentials.
require File.dirname(__FILE__) + '/dispatcher/scope'