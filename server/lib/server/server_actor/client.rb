# Represents a connected client.
class ServerActor::Client
  attr_reader :host, :port

  def initialize(host, port)
    @host = host
    @port = port
  end

  def to_s
    "#{@host}:#{@port}"
  end
end