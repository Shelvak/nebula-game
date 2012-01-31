module GameServer
  include LoggingServer
  include FlashPolicyHandler

  def post_init
    super
    debug "Registering to Dispatcher."
    Celluloid::Actor[:dispatcher].register! self
    @buffer = ""
  end

  def receive_data(data)
    if flash_policy_request?(data)
      info "Policy request got, responding."
      respond_with_policy
      # Disconnect upon flash policy, otherwise flash client gets stuck.
      close_connection_after_writing
    else
      @buffer += data
      newline_at = @buffer.index("\n")
      until newline_at.nil?
        Celluloid::Actor[:dispatcher].disconnect!(
          self, GenericServer::REASON_EMPTY_MESSAGE
        ) if newline_at == 0

        # Get our message.
        message = @buffer[0...newline_at]
        # Leave other part of buffer for further processing.
        @buffer = @buffer[(newline_at + 1)..-1]

        begin
          log_request do
            info "Message: #{message}"
            Celluloid::Actor[:dispatcher].receive! self, JSON.parse(message)
          end
        rescue JSON::ParserError => e
          debug "Cannot parse it out as JSON: #{e}\nMessage was: #{
            message.inspect}"
          Celluloid::Actor[:dispatcher].disconnect!(
            self, GenericServer::REASON_JSON_ERROR
          )
          return
        rescue Exception => e
          error "UNEXPECTED EXCEPTION: #{e.inspect}\nMessage:\n#{message
            }\nBacktrace:\n#{e.backtrace.join("\n")}"
          Celluloid::Actor[:dispatcher].disconnect(
            self, GenericServer::REASON_SERVER_ERROR
          )
          return
        end

        newline_at = @buffer.index("\n")
      end
    end
  end

  def send_message(message)
    json = JSON.generate(message)
    traffic_debug "Sending message: #{json}"
    send_data "#{json}\n"
  rescue Exception => e
    error "Failed while serializing: #{message.inspect}\n\n#{e.inspect
      }\n\n#{e.backtrace.join("\n")}"
    raise e
  end

  def unbind
    Celluloid::Actor[:dispatcher].unregister! self
    super
  end

  def to_s
    "GameServer:#{object_id}"
  end
end
