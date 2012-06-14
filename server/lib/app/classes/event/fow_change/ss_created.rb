# Notifies about created solar system.
class Event::FowChange::SsCreated < Event::FowChange::SolarSystem
  def initialize(solar_system_id, x, y, kind, players, metadatas)
    typesig binding, Fixnum, Fixnum, Fixnum, Fixnum, Array,
      SolarSystem::Metadatas

    @solar_system_id = solar_system_id
    @player_ids = players.map(&:id)
    @metadatas = players.each_with_object({}) do |player, hash|
      hash[player.id] = metadatas.for_created(
        solar_system_id, player.as_json(mode: :minimal),
        player.friendly_ids, player.alliance_ids,
        x, y, kind
      )
    end
  end
end