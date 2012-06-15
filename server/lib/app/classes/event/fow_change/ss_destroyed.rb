class Event::FowChange::SsDestroyed < Event::FowChange
  attr_reader :metadata

  def initialize(solar_system_id, player_ids)
    @metadata = SolarSystemMetadata.destroyed(solar_system_id)
    @player_ids = player_ids
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

  # TODO: spec
  def self.all_except(solar_system_id, player_id)
    player_ids = ::SolarSystem.observer_player_ids(solar_system_id)
    player_ids.delete(player_id)

    new(solar_system_id, player_ids)
  end

  # TODO: spec
  def self.by_player_and_ally(solar_system_id, player_id, alliance_id)
    player_ids = Set.new
    player_ids.add(player_id) unless player_id.nil?
    player_ids.merge(Alliance.player_ids_for(alliance_id)) \
      unless alliance_id.nil?

    new(solar_system_id, player_ids)
  end
end