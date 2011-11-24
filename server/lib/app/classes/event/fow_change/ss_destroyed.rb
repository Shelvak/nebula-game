class Event::FowChange::SsDestroyed < Event::FowChange
  attr_reader :metadata

  def initialize(solar_system_id, player_id, alliance_id)
    @player_ids = Set.new
    @player_ids.add(player_id) unless player_id.nil?
    @player_ids.merge(Alliance.find(alliance_id).member_ids) \
      unless alliance_id.nil?

    @metadata = SolarSystemMetadata.new({:id => solar_system_id})
  end
end