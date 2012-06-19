# Notifies about updated solar system.
class Event::FowChange::SsUpdated < Event::FowChange::SolarSystem
  def initialize(solar_system_id, players, metadatas)
    typesig binding, Fixnum, Array, ::SolarSystem::Metadatas

    @solar_system_id = solar_system_id
    @player_ids = players.map(&:id)
    @metadatas = players.each_with_object({}) do |player, hash|
      hash[player.id] = metadatas.for_existing(
        solar_system_id, player.id, player.friendly_ids, player.alliance_ids
      )
    end
  end
end