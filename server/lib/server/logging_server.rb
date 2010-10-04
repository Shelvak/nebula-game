module LoggingServer
  include NamedLogMessages

  def post_init
    @port, @ip = get_client_addr
    debug "Client connected from #{@ip}:#{@port}."
  end

  def get_client_addr
    Socket.unpack_sockaddr_in(get_peername)
  end

  def unbind
    debug "Client disconnected."
  end

  def log_request(message, &block)
    LOGGER.request(message, to_s, "#{@ip}:#{@port}", &block)
  end
end
