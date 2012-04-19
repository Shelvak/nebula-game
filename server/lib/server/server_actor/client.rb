# Represents a connected client.
class ServerActor::Client
  attr_reader :host, :port, :em_connection

  def initialize(host, port, em_connection)
    @host = host
    @port = port
    @em_connection = em_connection
  end

  def to_s
    "#{@host}:#{@port}"
  end
end