# Singleton Pool for +Chat::Hub+ instances for different galaxies.
class Chat::Pool
  include Singleton

  def initialize
    @hubs = {}
  end

  # Retrieves correct hub for _player_.
  def hub_for(player)
    galaxy_id = player.galaxy_id
    @hubs[galaxy_id] ||= Chat::Hub.new(Celluloid::Actor[:dispatcher])
    @hubs[galaxy_id]
  end
end