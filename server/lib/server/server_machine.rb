module ServerMachine
  include NamedLogMessages
  include FlashPolicyHandler

  def to_s
    @client.nil? ? "server" : "server-#{@client}"
  end

  def post_init
    port, ip = get_client_addr
    @client = ServerActor::Client.new(ip, port, self)
    info "Connected."
    Celluloid::Actor[:dispatcher].register!(@client)

    @buffer = StreamBuffer.new
  end

  def receive_data(data)
    # Force incoming data into utf-8 encoding.
    data.force_encoding(Encoding::UTF_8)

    if flash_policy_request?(data)
      info "Policy request got, responding."
      send_data policy_data
      # Disconnect upon flash policy, otherwise flash client gets stuck.
      close_connection_after_writing
    else
      @buffer.data(data)
      @buffer.each_message do |message|
        if message == ""
          send_data("ERROR: empty message\n")
          close_connection_after_writing
          return
        end

        debug "Received message: \"#{message}\""

        json = begin
          LOGGER.block(
            "Parsing message", :level => :debug, :component => to_s
          ) do
            JSON.parse(message)
          end
        rescue JSON::ParserError => e
          info "Cannot parse #{message.inspect} as JSON: #{e}"
          send_data("ERROR: not JSON\n")
          close_connection_after_writing
          return
        end

        Celluloid::Actor[:dispatcher].receive_message! @client, json
      end
    end
  end

  def write(message)
    json = begin
      LOGGER.block(
        "Serializing message", :level => :debug, :component => to_s
      ) do
        JSON.generate(message)
      end
    rescue Exception => e
      error "Failed while serializing message:\n\n#{
        message.inspect}\n\n#{e.to_log_str}", to_s
      close_connection_after_writing
      return
    end

    debug "Sending message: #{json}", to_s
    begin
      send_data "#{json}\n"
    rescue Java::java.lang.NullPointerException
      info "Failed while sending message, closing."
      close_connection_after_writing
    end
  end

  def unbind
    info "Disconnected."
    Celluloid::Actor[:dispatcher].unregister!(@client)
  end

  private

  def get_client_addr
    peername = get_peername
    if peername
      Socket.unpack_sockaddr_in(peername)
    else
      ["Unknown", "Unknown"]
    end
  end
end