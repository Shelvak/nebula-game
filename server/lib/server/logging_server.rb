module LoggingServer
  include NamedLogMessages

  def post_init
    @port, @ip = get_client_addr
    debug "Client connected from #{@ip}:#{@port}."
  end

  def get_client_addr
    peername = get_peername
    if peername
      Socket.unpack_sockaddr_in(peername)
    else
      ["Unknown", "Unknown"]
    end
  end

  def unbind
    debug "Client disconnected."
  end

  def log_request(&block)
    LOGGER.request(
      "REQUEST from #{@ip}:#{@port}", {:component => to_s}, &block
    )
  end
end
