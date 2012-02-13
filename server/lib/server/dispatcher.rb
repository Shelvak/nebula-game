class Dispatcher
  include NamedLogMessages
  include Celluloid

  attr_reader :storage

  TAG = 'dispatcher'
  
  # Special key for message id. This is needed for client to do time
  # syncing.
  MESSAGE_ID_KEY = 'id'
  # Disconnect action name.
  ACTION_DISCONNECT = 'players|disconnect'
  
  # Unhandled message was sent.
  DISCONNECT_UNHANDLED_MESSAGE = "unhandled_message"
  # Other player has logged in as you.
  DISCONNECT_OTHER_LOGIN = "other_login"
  # Player was erased from server.
  DISCONNECT_PLAYER_ERASED = "player_erased"
  
  class UnhandledMessage < StandardError; end

  # Initialize the dispatcher.
  def initialize
    @directors = {
      :chat => Threading::Director.new("chat", 1),
      :galaxy => Threading::Director.new("galaxy", 2),
      :player => Threading::Director.new("player", 5),
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

  # Register new client to dispatcher. This creates outgoing message queue.
  def register(client)
    info "Registering.", to_s(client)
    @storage[client] = {}
  end

  # Unregister connection from GameServer.
  def unregister(client)
    # Someone unregistered us before, probably from #disconnect
    return unless @storage.has_key?(client)

    info "Unregistering.", to_s(client)

    # FIXME: not threadsafe
    player = resolve_player(id)
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
  def change_player(client, player)
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

  # Receive message from _client_. Confirm receiving. Pass message to all
  # controllers.
  def receive(client, message)
    debug "Received message from [#{client}]: #{message.inspect}"

    message = message_object(client, message)
    info "Client ID: %s, player: %s" % [
      message.client_id,
      message.player.to_s
    ]

    unless message.client_id.nil?
      process_message(message)
    else
      info "Dropping message without client id.", to_s(client)
    end
  end

  def call(klass, method_name, *args)
    scope_method = "#{method_name}_scope"
    raise(
      "#{klass} is missing scope resolver for method call ##{method_name}"
    ) unless klass.respond_to?(scope_method)

    scope = klass.send(scope_method, *args)
    dispatch_work(scope, klass, method_name, *args)
  end

  # Transmit _message_ to clients identified by _ids_.
  def transmit(message, *clients)
    clients.each do |client|
      transmit_to_client(client, message)
    end
  end

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
    debug "Message: #{message.inspect}"

    options_method = "#{message.action}_options"
    scope_method = "#{message.action}_scope"
    action_method = "#{message.action}_action"

    controller_class = @controllers[message.controller_name]
    raise UnhandledMessage.new(
      "No such controller: #{message.controller_name}"
    ) if controller_class.nil?
    raise UnhandledMessage.new(
      "No such action: #{message.action}"
    ) unless controller_class.respond_to?(action_method)

    # Check options.
    unless controller_class.respond_to?(options_method)
      error "#{message.full_action} is missing options method!"
      raise UnhandledMessage
    end
    controller_class.send(options_method).check!(message)

    unless controller_class.respond_to?(scope_method)
      error "#{message.full_action} is missing scope resolver method!"
      raise UnhandledMessage
    end
    scope = controller_class.send(scope_method, message)

    dispatch_work(scope, controller_class, action_method, message)
  rescue ParamOpts::BadParams => e
    # TODO
  rescue UnhandledMessage => e
    disconnect(message.client, DISCONNECT_UNHANDLED_MESSAGE, e.message)
  end

  def dispatch_work(scope, klass, method, *args)
    typesig binding, Scope, Class, Symbol, Array

    if scope.chat?
      name = :chat
    elsif scope.galaxy?
      name = :galaxy
    elsif scope.player?
      name = :player
    else
      raise ArgumentError, "Unknown dispatcher work scope: #{scope.inspect}!"
    end

    director = @directors[name]
    raise "Unknown director #{name.inspect}!" if director.nil?

    info "Dispatching work to director #{name}: #{
      klass}.#{method}#{args.inspect}"
    director.work!(scope.ids, klass, method, *args)
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

  # Confirm client of _message_ receiving. Set _failed_ to inform client
  # that his last action has failed.
  def confirm_receive_by_client(client, message, error=nil)
    confirmation = {'reply_to' => message.id}
    if error
      confirmation['failed'] = true
      confirmation['error'] = {
        'type' => error.class.to_s,
        'message' => error.message
      }
      info "Sending failure message."
    else
      info "Sending confirmation message."
    end
    transmit_to_client(client, confirmation)
  end

  # Set message id and push it into outgoing messages stack for given IO.
  def transmit_to_client(client, message)
    message[MESSAGE_ID_KEY] = next_message_id
    Actor[:server].write!(client, message)
  end
end
