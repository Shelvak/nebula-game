# Singleton Pool for +Chat::Hub+ instances for different galaxies.
class Chat::Pool
  include Singleton
  include MonitorMixin

  def initialize
    super()
    @hubs = {}
  end

  # Retrieves correct hub for _player_.
  def hub_for(player)
    synchronize do
      galaxy_id = player.galaxy_id
      @hubs[galaxy_id] ||= Chat::Hub.new(:dispatcher)
    end
  end
end