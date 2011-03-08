module ControlServer
  include LoggingServer

  def post_init
    super
  end

  def receive_data(data)
    disconnect(GenericServer::REASON_EMPTY_MESSAGE) if data == ""

    log_request "Message: #{data}" do
      ControlManager.instance.receive self, JSON.parse(data)
    end
  rescue JSON::ParserError => e
    debug "Cannot parse it out as JSON: #{e}\nMessage was: #{data.inspect}"
    disconnect(GenericServer::REASON_JSON_ERROR)
  rescue Exception => e
    error "UNEXPECTED EXCEPTION: #{e.inspect}\nBacktrace:\n#{
      e.backtrace.join("\n")}"
    disconnect(GenericServer::REASON_SERVER_ERROR)
  end

  def disconnect(reason)
    send_message({'disconnect_reason' => reason})
    close_connection_after_writing
  end

  def send_message(message)
    json = JSON.generate(message)
    traffic_debug "Sending message: #{json}"
    send_data "#{json}\n"
  end

  def unbind
    super
  end

  def to_s
    "ControlServer:#{object_id}"
  end
end
