class Dispatcher
  include NamedLogMessages
  include Celluloid

  TAG = 'dispatcher'
  
  # Special key for message id. This is needed for client to do time
  # syncing.
  MESSAGE_ID_KEY = 'id'
  # Disconnect action name.
  ACTION_DISCONNECT = 'players|disconnect'

  # Other player has logged in as you.
  DISCONNECT_OTHER_LOGIN = "other_login"
  # Player was erased from server.
  DISCONNECT_PLAYER_ERASED = "player_erased"
  
  class UnhandledMessage < StandardError; end
  class UnresolvableScope < StandardError; end

  # Initialize the dispatcher.
  def initialize
    @director_supervisors = {
      :chat => Threading::Director.supervise("chat", 1),
      :galaxy => Threading::Director.supervise("galaxy", 2),
      :player => Threading::Director.supervise("player", 5),
    }

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

    @client_to_player = {}
    @player_id_to_client = {}
    # Session level storage to store data between controllers
    @storage = {}

    #@event_handler = DispatcherEventHandler.new(self)
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

    info "Unregistering.", to_s(client)

    player = resolve_player(client)
    unless player.nil?
      player.last_seen = Time.now
      player.save!

      # There is no point of notifying about leaves if server is shutdowning.
      # Also this generates NPE in buggy EM version.
      unless App.server_shutdowning?
        Chat::Pool.instance.hub_for(player).unregister(player)
      end
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
    debug "Registering #{client} as #{player}.", to_s(client)

    if player_connected?(player.id)
      client = @player_id_to_client[player.id]
      disconnect(client, DISCONNECT_OTHER_LOGIN)
    end

    @client_to_player[client] = player
    # FIXME: not threadsave!
    Chat::Pool.instance.hub_for(player).register(player)
  end

  # Update player entry if player is connected.
  def update_player(player)
    client = @player_id_to_client[player.id]
    if client
      @client_to_player[client] = player
    else
      raise "Cannot update player #{player} which is not registered!"
    end
  end

  # Receive message hash from _client_.
  def receive(client, message_hash)
    log_tag = to_s(client)

    debug "Received message hash: #{message_hash.inspect}", log_tag

    message = message_object(client, message_hash)
    LOGGER.block(
      "Received message. (player: #{message.player || "none"})",
      :component => log_tag
    ) { process_message(message) }
  end

  def call(klass, method_name, *args)
    scope_method = "#{method_name}_scope"
    raise(
      "#{klass} is missing scope resolver for method call ##{method_name}"
    ) unless klass.respond_to?(scope_method)

    scope = klass.send(scope_method, *args)
    signature = "#{TAG}.call: #{klass}.#{method_name}#{args.inspect}"
    dispatch_task(scope, Threading::Director::Task.new(signature) do
      klass.send(method_name, *args)
    end)
  end

  # Confirm client of _message_ receiving. Set error to inform client
  # that his last action has failed.
  def confirm_receive(message, error=nil)
    typesig binding, Message, [NilClass, Exception]

    confirmation = {'reply_to' => message.id}
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
  def disconnect(client_or_id, reason=nil, error_message=nil)
    client = client_or_id.is_a?(Fixnum) \
      ? @id_to_client[client_or_id] : client_or_id
    return if client.nil?

    transmit_to_client(client, {
      "action" => ACTION_DISCONNECT,
      "params" => {"reason" => reason, "error" => error_message}
    })
    unregister client
    Actor[:server].disconnect!(client)
  end

  # Transmit _message_ to clients identified by _ids_.
  def transmit(message, *clients)
    clients.each do |client|
      transmit_to_client(client, message)
    end
  end

  # Threadsafe storage getter.
  def storage_get(client, key); @storage[client][key]; end
  # Threadsafe storage setter.
  def storage_set(client, key, value); @storage[client][key] = value; end

  # Solar system ID which is currently viewed by client.
  def current_ss_id(client); @storage[client][:current_ss_id]; end
  # SsObject ID which is currently viewed by client.
  def current_planet_id(client)
    @storage[client][:current_planet_id]
  end
  
  # Pushes message to all logged in players.
  def push_to_logged_in(action, params={})
    @client_to_player.each do |client, _|
      push(client, action, params)
    end
  end

  # Push message to client if he's connected.
  #
  # Filters can be:
  # - nil: no filter
  # - Dispatcher::PushFilter[]: if one of them matches, message is passed
  # through.
  #
  def push(client, action, params, filters=nil)
    log = "action #{action.inspect} with params #{params.inspect} and filters #{
      filters.inspect}."
    if client_connected?(client) && push_filters_match?(client, filters)
      debug "Pushing #{log}", to_s(client)
      message = message_object(
        client,
        {"action" => action, "params" => params},
        true
      )
      process_message(message)
    else
      debug "Pushing #{log}", to_s(client)
    end
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

  protected

  def process_message(message)
    log_str = to_s(message.client)

    options_method = "#{message.action}_options"
    scope_method = "#{message.action}_scope"
    action_method = "#{message.action}_action"

    controller_class = @controllers[message.controller_name]
    raise UnhandledMessage.new(
      "No such controller: #{message}"
    ) if controller_class.nil?
    raise UnhandledMessage.new(
      "No such action: #{message}"
    ) unless controller_class.respond_to?(action_method)

    # Check options.
    unless controller_class.respond_to?(options_method)
      error_str = "#{message.full_action} is missing options method!"
      error error_str, log_str
      raise UnhandledMessage.new(error_str)
    end
    controller_class.send(options_method).check!(message)

    unless controller_class.respond_to?(scope_method)
      error_str = "#{message.full_action} is missing scope resolver method!"
      error error_str, log_str
      raise UnhandledMessage.new(error_str)
    end

    scope = resolve_scope(controller_class, scope_method, message)
    task = ControllerTask.create(controller_class, action_method, message)
    dispatch_task(scope, task)
  rescue GenericController::ParamOpts::BadParams, UnhandledMessage,
      UnresolvableScope => e
    info "Cannot process #{message} - #{e.class}: #{e.message}", log_str
    confirm_receive(message, e)
  end

  # Try to resolve scope and handle errors properly.
  def resolve_scope(klass, method, *args)
    klass.send(method, *args)
  rescue UnresolvableScope => e
    raise e
  rescue Exception => e
    error "Error while resolving scope with #{klass}.#{method}#{args.inspect
      }!\n\n#{e.to_log_str}"
    raise UnresolvableScope, e.message, e.backtrace
  end

  # Dispatches a +Threading::Director::Task+ to appropriate
  # +Threading::Director+ according to its +Dispatcher::Scope+.
  def dispatch_task(scope, task)
    typesig binding, Scope, Threading::Director::Task

    if scope.chat?
      name = :chat
    elsif scope.galaxy?
      name = :galaxy
    elsif scope.player?
      name = :player
    else
      raise ArgumentError, "Unknown dispatcher work scope: #{scope.inspect}!"
    end

    supervisor = @director_supervisors[name]
    raise "Unknown director #{name.inspect}!" if supervisor.nil?

    info "Dispatching to #{name} director: scope=#{scope} task=#{task}"
    director = supervisor.actor
    director.work!(scope.ids, task)
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
      message['action'] || "",
      message['params'] || {},
      client,
      @client_to_player[client],
      pushed
    )
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
