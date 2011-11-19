# Indicates that Galaxy#apocalypse_start has been set.
class Event::ApocalypseStart
  # Galaxy ID for which apocalypse has started.
  attr_reader :galaxy_id
  # Start +Time+ of apocalypse
  attr_reader :start

  # @param galaxy_id [Fixnum]
  # @param start [Time]
  def initialize(galaxy_id, start)
    @galaxy_id = galaxy_id
    @start = start
  end
end