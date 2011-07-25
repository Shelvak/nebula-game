class GenericController
  MESSAGE_SPLITTER = "|"
  # Used to distinguish which methods are used as actions.
  ACTION_RE = /^action_/

  class ActionFiltered < GameError; end
  class UnknownAction < GameError; end
  class PushRequired < StandardError; end

  attr_reader :dispatcher, :params, :client_id, :player

  # Controllers get messages in this order
  def self.priority; 0; end

  def initialize(dispatcher)
    @dispatcher = dispatcher
    @known_actions = methods.grep(ACTION_RE).map do |name|
      name.to_s.sub(ACTION_RE, '')
    end
  end

  # Login _player_ and save its last login.
  def login(player)
    raise ArgumentError.new(
      "1st argument should be Player instance instead of #{player.inspect}"
    ) unless player.is_a?(Player)

    player.last_login = Time.now
    player.save!
    
    @dispatcher.change_player(@client_id, player)

    # Other controllers may depend on this
    @client_id = player.id
    @player = player
    # Also update current message for other controllers in a chain
    if @current_message
      @current_message['client_id'] = @client_id
      @current_message['player'] = @player
    end

    session[:ruleset] = @player.galaxy.ruleset
  end

  def logged_in?
    not @player.nil?
  end

  def pushed?
    @pushed
  end

  def disconnect(message=nil)
    @dispatcher.disconnect(@client_id, message)
  end

  def receive(message)
    @current_message = message
    # Don't depend on message[key] being updated!
    @client_id = message['client_id']
    @player = message['player']
    @params = message['params'] || {}
    @pushed = message['pushed']
    @action = message['action']

    raise ActionFiltered unless before_invoke!

    action = @action.split(MESSAGE_SPLITTER)[1]
    action_known!(action)
    handler = :"action_#{action}"

    if session[:ruleset]
      CONFIG.with_set_scope(session[:ruleset]) do
        send(handler)
      end
    else
      send(handler)
    end
  end

  def respond(params={})
    @dispatcher.transmit({
      'action' => @current_message['action'],
      'params' => params}, @client_id)
    true
  end

  def push(action, params={})
    @dispatcher.push({
      'action' => action,
      'params' => params
    }, @client_id)
    true
  end

  def session
    @dispatcher.storage[@client_id]
  end

  # Solar system ID which is currently viewed by client.
  def current_ss_id; session[:current_ss_id]; end
  def current_ss_id=(value); session[:current_ss_id] = value; end
  # SsObject ID which is currently viewed by client.
  def current_planet_id; session[:current_planet_id]; end
  def current_planet_id=(value); session[:current_planet_id] = value; end
  # Solar System ID of planet which is currently viewed by client.
  def current_planet_ss_id; session[:current_planet_ss_id]; end
  def current_planet_ss_id=(value); session[:current_planet_ss_id] = value; end

  # Current action name.
  def action; @action; end

  protected
  # Check if we can process this action.
  def before_invoke!
    if logged_in?
      return true
    else
      case @action
      when 'players|login', 'combat_logs|show'
        return true
      else
        disconnect "Not logged in."
        return false
      end
    end
  end

  # Check if given action is known.
  def action_known!(action)
    raise UnknownAction.new("Unknown action #{action}, known actions: #{
      @known_actions.inspect}") unless @known_actions.include?(action)
  end

  # Ensure params options.
  #
  # * <tt>:required</tt>: these params are required. ArgumentError is raised
  #    if they are not supplied.
  # * <tt>:valid</tt>: these params are valid. ArgumentError is raised
  #    if param not from this list is supplied.
  #
  def param_options(options={})
    required = (options[:required] || [])
    if required.is_a?(Array)
      required = required.inject({}) { |hash, item| hash[item] = true; hash }
    elsif ! required.is_a?(Hash)
      required = {required => true}
    end
    
    required.each do |param, type|
      param = param.to_s
      
      raise ControllerArgumentError.new(
        "#{param} is required, but was not provided for action #{
          @current_message['action']}"
      ) unless params.has_key?(param)
      
      if type != true
        raise ControllerArgumentError.new(
          "#{param} should have been #{type}, but was #{params[param].class
            } for action #{@current_message['action']}"
        ) unless params[param].is_a?(type)
      end
    end

    if options[:valid]
      valid = (options[:valid] || [])
      valid = [valid] unless valid.is_a?(Array)
      valid += required.stringify_keys.keys
      params.assert_valid_keys(valid)
    end
  end

  # Raises PushRequired unless request is pushed.
  def only_push!
    raise PushRequired unless pushed?
  end
end
