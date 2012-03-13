# Singleton Pool for +Chat::Hub+ instances for different galaxies.
class Chat::Pool
  include Singleton

  def initialize
    @hubs = {}
    @mutex = Mutex.new
  end

  # Retrieves correct hub for _player_.
  def hub_for(player)
    @mutex.synchronize do
      galaxy_id = player.galaxy_id
      @hubs[galaxy_id] ||= Chat::Hub.new(:dispatcher)
    end
  end
end