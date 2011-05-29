module ControllerSpecHelper
  def mock_dispatcher
    dispatcher_mock = mock(Dispatcher)
    
    storage_mock = mock(Hash)
    storage_mock.stub!(:'[]').and_return({})
    dispatcher_mock.stub!(:storage).and_return(storage_mock)

    dispatcher_mock.stub!(:change_player).and_return(true)
    dispatcher_mock.stub!(:transmit).and_return(true)
    def dispatcher_mock.push(message, client_id)
      @pushed_messages ||= {}
      @pushed_messages[client_id] ||= []
      @pushed_messages[client_id].push message
    end
    def dispatcher_mock.pushed_messages
      @pushed_messages || {}
    end
    dispatcher_mock.stub!(:push_to_player).and_return(true)
    dispatcher_mock.stub!(:update_player).and_return(true)

    dispatcher_mock
  end

  def init_controller(klass, options={})
    @dispatcher = mock_dispatcher
    @controller = klass.new(@dispatcher)
    @controller.instance_variable_set("@client_id",
      DEFAULT_SPEC_CLIENT_ID)
    def @controller.response; @response; end
    def @controller.respond_params; response; end
    def @controller.response_params; response; end

    def @controller.respond(params)
      @response = params
      true
    end

    @client_id = DEFAULT_SPEC_CLIENT_ID
    login(
      options[:login] == true ? nil : options[:login]
    ) if options[:login]
  end

  def client_id
    @client_id
  end

  def player
    @player
  end

  def login(player=nil)
    player ||= Factory.create :player
    @controller.login(player)
    @client_id = player.id
    @player = player
  end

  def should_respond_with(what)
    @controller.should_receive(:respond).with(what)
  end

  def response
    @controller.response
  end

  def session
    @controller.session
  end

  def response_should_include(what)
    what.each do |key, value|
      @controller.response[key].should == value
    end
  end

  def should_push(action, params={})
    @dispatcher.should_receive(:push).with({
      'action' => action,
      'params' => params
    }, @client_id)
  end

  def should_not_push(action, params={})
    @dispatcher.should_not_receive(:push).with({
      'action' => action,
      'params' => params
    }, @client_id)
  end

  def invoke(action, params={})
    @controller.receive(create_message(action, params))
  end

  def push(action, params={})
    message = create_message(action, params)
    message['pushed'] = true
    @controller.receive(message)
  end

  def create_message(action, params)
    {
      'action' => action,
      'params' => params,
      'client_id' => @client_id,
      'player' => @player
    }
  end
end