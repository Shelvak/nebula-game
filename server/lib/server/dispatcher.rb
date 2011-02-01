class Dispatcher
  include NamedLogMessages
  include Singleton

  attr_reader :storage

  # Initialize the dispatcher.
  def initialize
    @unknown_client_id = 0
    @last_message_id = 0
    @controllers = []
    Dir.glob(
      File.join(ROOT_DIR, 'lib', 'app', 'controllers', '*.rb')
    ).each do |file|
      class_name = File.basename(file).sub(/\.rb$/, '').camelcase

      debug "Adding #{class_name} to dispatcher."
      @controllers.push class_name.constantize.new(self)
    end
    @controllers.sort_by { |c| c.class.priority }

    @client_id_to_player = {}
    @client_id_to_io = {}
    @io_to_client_id = {}
    # Session level storage to store data between controllers
    @storage = {}

    # Message processing queue
    @message_queue = []

    @event_handler = DispatcherEventHandler.new(self)
  end

  # Register new connection on GameServer to dispatcher. This creates outgoing
  # message queue.
  def register(io)
    id = next_unknown_client_id
    info "Registering [#{io}] as client #{id}"
    @client_id_to_io[id] = io
    @io_to_client_id[io] = id
    @storage[id] = {}
  end

  # Unregister connection from GameServer.
  def unregister(io)
    id = @io_to_client_id[io]
    # Someone unregistered us before, probably from #disconnect
    unless id.nil?
      info "Unregistering [#{io}] (client id #{id})"

      # Filter message queue to remove this client messages.
      @message_queue = @message_queue.reject do |message|
        message['client_id'] == id
      end

      each_storage_by_client_id do |storage|
        storage.delete id
      end

      @io_to_client_id.delete io
    end
  end

  # Change current player associated with current player id.
  def change_player(current_client_id, player)
    raise ArgumentError.new("player should be Player object but #{
      player.inspect} was given") unless player.is_a?(Player)

    debug "Changing client id #{current_client_id} to #{player}"
    change_client_id(current_client_id, player.id)
    @client_id_to_player.delete current_client_id
    @client_id_to_player[player.id] = player
  end

  # Update player entry if player is connected.
  def update_player(player)
    if @client_id_to_player[player.id]
      @client_id_to_player[player.id] = player
    else
      raise StandardError.new(
        "Cannot update player which is not registered!"
      )
    end
  end

  # Receive message from _server_. Confirm receiving. Pass message to all
  # controllers.
  def receive(io, message)
    debug "Received message from [#{io}]: #{message.inspect}"

    assign_message_vars!(io, message)
    info "Client ID: %s, player: %s" % [
      message['client_id'],
      message['player'].to_s
    ]

    unless message['client_id'].nil?
      failed = false

      # Catch game logic errors and say to client that this action failed.
      begin
        process_message(message)
      rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid,
          GameError
        failed = true
      end
      confirm_receive_by_io(io, message, failed)
    else
      info "Dropping message without client id."
    end
  end

  # Transmit _message_ to clients identified by _ids_.
  def transmit(message, *ids)
    ids.each do |id|
      io = @client_id_to_io[id]
      # io may be nil if client is disconnected
      transmit_by_io(io, message) unless io.nil?
    end
  end

  # Solar system ID which is currently viewed by client.
  def current_ss_id(client_id); @storage[client_id][:current_ss_id]; end
  # SsObject ID which is currently viewed by client.
  def current_planet_id(client_id)
    @storage[client_id][:current_planet_id]
  end

  # Push message to player if he's connected.
  #
  # Filters can be:
  # - nil: no filter
  # - DispatcherPushFilter[]: if one of them matches, message is passed
  # through.
  #
  def push_to_player(client_id, action_or_message, params={}, filters=nil)
    if connected?(client_id)
      return unless push_filters_match?(client_id, filters)

      if action_or_message.is_a?(Hash)
        message = action_or_message
      else
        message = {'action' => action_or_message, 'params' => params}
      end

      push(message, client_id)
    end
  end

  # Push message from one controller to processing queue.
  def push(message, client_id)
    debug "Pushing #{message.inspect} to client #{client_id.inspect}"
    assign_message_vars!(client_id, message)
    message['pushed'] = true

    process_message(message)
  end

  # Friendly string name
  def to_s
    self.class.to_s
  end

  # Disconnect client. Send message and close connection.
  def disconnect(io_or_id, reason=nil, cancel_handling=true)
    io = io_or_id.is_a?(Fixnum) ? @client_id_to_io[io_or_id] : io_or_id

    transmit_by_io(io, {
      "action" => PlayersController::ACTION_DISCONNECT,
      "params" => {"reason" => reason}
    })
    io.close_connection_after_writing
    unregister io
    # Don't pass message to other controllers, we're done.
    throw :stop_message_handling if cancel_handling && queue_in_processing?
  end

  # Is client with _id_ connected?
  def connected?(id)
    ! @client_id_to_io[id].nil?
  end

  protected
  # Check if one of the given push filters match for current client.
  # TODO: spec
  def push_filters_match?(client_id, filters)
    return true if filters.nil?

    filters = filters.is_a?(Array) ? filters : [filters]
    filters.each do |filter|
      return true if filter.nil?

      case filter.scope
      when DispatcherPushFilter::SOLAR_SYSTEM
        return true if current_ss_id(client_id) == filter.id
      when DispatcherPushFilter::SS_OBJECT
        return true if current_planet_id(client_id) == filter.id
      else
        raise ArgumentError.new("Unknown filter scope: #{
          filter.scope.inspect}")
      end
    end

    false
  end

  # Assign client_id and player to _message_ and log assignation.
  def assign_message_vars!(io_or_client_id, message)
    message['client_id'] = io_or_client_id.is_a?(Fixnum) \
      ? io_or_client_id : @io_to_client_id[io_or_client_id]
    message['player'] = @client_id_to_player[
      message['client_id']
    ]

    message
  end

  def process_message(message)
    @message_queue.push message
    process_queue
  end

  def queue_in_processing?
    @queue_processing
  end

  # Processes messages in message queue
  def process_queue
    if queue_in_processing?
      LOGGER.debug "Message queue is currently being processed, returning."
      return
    end

    LOGGER.block("Message queue processing", :level => :debug,
    :server_name => to_s) do
      @queue_processing = true
      until @message_queue.blank?
        handle_message(@message_queue.shift)
      end
      @queue_processing = false
    end
  # Ensure that even if we fail somewhere while handling the message, 
  # the queue should be unmarked as still processing.
  #
  # Don't use ensure because it's executed even if we return early.
  rescue 
    @queue_processing = false
    fail
  end

  # Handle message with controllers
  def handle_message(message)
    LOGGER.block("Message handling", :level => :debug,
    :server_name => to_s) do
      debug "Message: #{message.inspect}"

      handled = false
      catch :stop_message_handling do
        @controllers.each do |controller|
          # TODO: write appropriate handler machine instead of looping
          # through loop.
          handled = true unless controller.receive(message).nil?
        end

        disconnect(message['client_id'], "unhandled_message") unless handled
      end
    end
  end

  # Change client to IO mapping from _from_ to _to_.
  #
  # This should only be called from #change_player
  def change_client_id(from, to)
    disconnect(to, "other_login", false) if connected?(to)

    info "Changing client id from #{from} to #{to}"
    @io_to_client_id[ @client_id_to_io[from] ] = to

    each_storage_by_client_id do |storage|
      storage[to] = storage[from]
      storage.delete from
    end
  end

  # Yield each storage that is accessed by client id
  def each_storage_by_client_id
    [@client_id_to_io, @client_id_to_player, @storage].each do |storage|
      yield storage
    end
  end

  # Get next id for unknown client (not logged in). Returns negative number.
  def next_unknown_client_id
    @unknown_client_id -= 1
    # Protect for number overflow
    @unknown_client_id = -1 if @unknown_client_id >= 0
    @unknown_client_id
  end
  
  # Return new pseudo-unique ID for message.
  def next_message_id
    "%d" % (Time.now.to_f * 1000)
  end

  # Special key for message id. This is needed for client to do time
  # syncing.
  MESSAGE_ID_KEY = 'id'

  # Confirm client of _message_ receiving. Set _failed_ to inform client
  # that his last action has failed.
  def confirm_receive_by_io(io, message, failed=false)
    confirmation = {'reply_to' => message[MESSAGE_ID_KEY]}
    confirmation['failed'] = true if failed
    transmit_by_io(io, confirmation)
  end

  # Set message id and push it into outgoing messages stack for given IO.
  def transmit_by_io(io, message)
    message[MESSAGE_ID_KEY] = next_message_id
    io.send_message message
  end
end
