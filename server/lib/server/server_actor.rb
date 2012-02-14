class ServerActor
  include NamedLogMessages
  include FlashPolicyHandler
  include Celluloid
  include Celluloid::IO

  def initialize(port)
    @server = Celluloid::IO::TCPServer.new("0.0.0.0", port)

    # client -> socket
    @sockets = {}

    # We depend on dispatcher, if it crashes, we crash too.
    current_actor.link Actor[:dispatcher]

    run!
  end

  def to_s(client=nil)
    client.nil? ? "server" : "server-#{client}"
  end

  # Runs main loop which is responsible for accepting connections.
  def run
    info "Starting main event loop."
    loop do
      socket = @server.accept
      _, port, host = socket.peeraddr
      client = Client.new(host, port)

      handle! socket, client
    end
  end

  # Clean up upon actor exit.
  def finalize
    @server.close unless @server.nil?
  end

  # Handles one client connection.
  def handle(socket, client)
    @sockets[client] = socket
    info "Connected.", to_s(client)
    Actor[:dispatcher].register!(client)

    buffer = StreamBuffer.new

    loop do
      # Read some data from the socket.
      data = socket.readpartial(4096)

      if flash_policy_request?(data)
        info "Policy request got, responding.", to_s(client)
        socket.write(policy_data)
        # Disconnect upon flash policy, otherwise flash client gets stuck.
        socket.close
        return
      else
        buffer.data(data)
        buffer.each_message do |message|
          if message == ""
            socket.write("ERROR: empty message\n")
            socket.close
            return
          end

          info "Received message: \"#{message}\"", to_s(client)

          json = begin
            JSON.parse(message)
          rescue JSON::ParserError => e
            info "Cannot parse #{message.inspect} as JSON: #{e}", to_s(client)
            socket.write("ERROR: not JSON\n")
            socket.close
            return
          end

          Actor[:dispatcher].receive_message! client, json
        end
      end
    end
  rescue EOFError
    # Our client has disconnected.
  ensure
    client_disconnected(client)
  end

  # Write _message_ serialized as JSON to socket associated with _client_.
  def write(client, message)
    socket = @sockets[client]
    if socket.nil?
      info "Message write aborted, socket not found:\n#{message}", to_s(client)
      return
    end

    json = begin
      JSON.generate(message)
    rescue Exception => e
      error "Failed while serializing message:\n\n#{
        message.inspect}\n\n#{
        e.to_log_str}",
        to_s(client)
      socket.close
      return
    end

    debug "Sending message: #{json}", to_s(client)
    socket.write "#{json}\n"
  rescue EOFError, IOError
    # Our client has disconnected.
    client_disconnected(client)
  end

  def disconnect(client, message=nil)
    write(client, message) unless message.nil?

    socket = @sockets[client]
    socket.close if socket && ! socket.closed?
  end

  private
  def client_disconnected(client)
    Actor[:dispatcher].unregister!(client)
    @sockets.delete client
    info "Disconnected.", to_s(client)
  end
end
