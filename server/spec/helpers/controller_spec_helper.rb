module ControllerSpecHelper
  def init_controller(klass, options={})
    @controller = klass.dup
    @controller.instance_eval do
      def __set_controller_name(value); @controller_name = value; end
      def inspect; "<#{@controller_name} dupped>"; end
      def to_s; inspect; end

      @session = {}
      def session; @session; end
      def session_get(message, key); @session[key]; end
      def session_set(message, key, value); @session[key] = value; end

      def response; @response; end
      def respond_params; response; end
      def response_params; response; end
      def respond(message, params)
        typesig binding, Dispatcher::Message, Hash

        @response = params
      end

      def pushed; @pushed ||= []; end
      def pushed?(action, params)
        pushed.include?([action, params.stringify_keys])
      end
      def push(message, action, params={})
        typesig binding, Dispatcher::Message, String, Hash

        pushed << [action, params.stringify_keys]
      end
    end
    @controller.__set_controller_name(klass.to_s)

    @controller_name = klass.to_s.underscore.sub(/_controller$/, '')
    @message_id = "10101" # Fake message id.
    @seq = 0 # Fake sequence number.
    @client = ServerActor::Client.new("127.0.0.1", 12345)

    login(
      options[:login] == true ? nil : options[:login]
    ) if options[:login]
  end

  %w{ruleset current_ss_id current_planet_id current_planet_ss_id}.each do
    |session_var|

    define_method(session_var) { @controller.send(session_var, nil) }
    define_method("#{session_var}=") do |value|
      @controller.send("set_#{session_var}", nil, value)
    end
  end

  def player
    @player
  end

  def login(player=nil)
    @player = player || Factory.create(:player)
    self.ruleset = @player.galaxy.ruleset
  end

  def response
    @controller.response
  end

  def session
    @controller.session
  end

  def should_respond_with(what)
    @controller.should_receive(:respond).with(
      an_instance_of(Dispatcher::Message), what
    )
  end

  def response_should_include(what)
    @controller.response.only(what.keys).should equal_to_hash(what)
  end

  def response_should_be(what)
    @controller.response.should equal_to_hash(what)
  end

  def should_have_pushed(action, params={})
    @controller.pushed?(action, params).should be_true
  end

  def should_push(action, params={})
    @controller.should_receive(:push).with(
      an_instance_of(Dispatcher::Message), action, params
    )
  end

  def should_have_not_pushed(action, params={})
    @controller.pushed?(action, params).should be_false
  end

  def should_not_push(action, params={})
    @controller.should_not_receive(:push)..with(
      an_instance_of(Dispatcher::Message), action, params
    )
  end

  def invoke(action, params={})
    message = create_message(action, params, false, !! @player)
    send_message(message)
  end

  def push(action, params={})
    message = create_message(action, params, true, !! @player)
    send_message(message)
  end

  def create_message(action, params, pushed, logged_in=true)
    raise "Cannot log in player, but it is required!" \
      if logged_in && @player.nil?
    Dispatcher::Message.new(
      @message_id, @seq, action, params, @client, logged_in ? @player : nil,
      pushed
    )
  end

  def send_message(message)
    @controller.send("#{message.action}_action", message)
  end

  def check_options!(message)
    const = "#{message.action.upcase}_OPTIONS"
    @controller.const_get(const).check!(message)
  end
end