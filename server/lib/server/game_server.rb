module GameServer
  include LoggingServer
  include FlashPolicyHandler

  def post_init
    super
    debug "Registering to Dispatcher."
    Dispatcher.instance.register self
  end

  def receive_data(data)
    if flash_policy_request?(data)
      respond_with_policy
    else
      Dispatcher.instance.disconnect(
        self, GenericServer::REASON_EMPTY_MESSAGE
      ) if data == ""

      # Sometimes client sends two messages as 1.
      data.split("\n").each do |part|
        begin
          log_request "Message: #{part}" do
            Dispatcher.instance.receive self, JSON.parse(part)
          end
        rescue JSON::ParserError => e
          debug "Cannot parse it out as JSON: #{e}\nMessage was: #{
            part.inspect}"
          Dispatcher.instance.disconnect(self,
            GenericServer::REASON_JSON_ERROR)
          return
        end
      end
    end
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
