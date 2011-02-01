module GameServer
  include LoggingServer

  def post_init
    super
    debug "Registering to Dispatcher."
    Dispatcher.instance.register self
  end

  def receive_data(data)
    Dispatcher.instance.disconnect(
      self, GenericServer::REASON_EMPTY_MESSAGE
    ) if data == ""

    log_request "Message: #{data}" do
      Dispatcher.instance.receive self, JSON.parse(data)
    end
  rescue JSON::ParserError => e
    debug "Cannot parse it out as JSON: #{e}\nMessage was: #{data.inspect}"
    Dispatcher.instance.disconnect(self, GenericServer::REASON_JSON_ERROR)
  rescue Exception => e
    error "UNEXPECTED EXCEPTION: #{e.inspect}\nBacktrace:\n#{
      e.backtrace.join("\n")}"
    Dispatcher.instance.disconnect(self, GenericServer::REASON_SERVER_ERROR)
  end

  def send_message(message)
    json = message.to_json
    traffic_debug "Sending message: #{json}"
    send_data "#{json}\n"
  end

  def unbind
    Dispatcher.instance.unregister self
    super
  end

  def to_s
    "GameServer:#{object_id}"
  end
end
