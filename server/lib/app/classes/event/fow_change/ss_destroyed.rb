class Event::FowChange::SsDestroyed < Event::FowChange::SolarSystem
  attr_reader :metadata

  def initialize(solar_system_id, player_ids)
    @player_ids = player_ids
    @metadata = SolarSystemMetadata.destroyed(solar_system_id)
  end

  def to_s
    "<#{self.class} player_ids=#{@player_ids.inspect} metadata=#{
      @metadata.to_s}>"
  end

  def ==(other); eql?(other); end

  def eql?(other)
    other.is_a?(self.class) && @player_ids == other.player_ids &&
      @metadata == other.metadata
  end

  # Return event for _solar_system_id_ where every observer except _player_id_
  # is notified.
  def self.all_except(solar_system_id, player_id)
    player_ids = ::SolarSystem.observer_player_ids(solar_system_id)
    player_ids.delete(player_id)

    new(solar_system_id, player_ids)
  end
end