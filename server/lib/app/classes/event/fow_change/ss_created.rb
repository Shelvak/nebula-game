# Notifies about created solar system.
class Event::FowChange::SsCreated < Event::FowChange::SolarSystem
  # @param [Fixnum] solar_system_id ID of solar system
  # @param [Fixnum] x X of solar system
  # @param [Fixnum] y Y of solar system
  # @param [Fixnum] kind kind of solar system
  # @param [Fixnum] player_minimal Player#minimal of solar system owner.
  # @param [Array] players Array[Player] to which this event should be
  # dispatched.
  # @param [SolarSystem::Metadatas] metadatas metadatas for given ss.
  def initialize(
    solar_system_id, x, y, kind, player_minimal, players, metadatas
  )
    typesig binding, Fixnum, Fixnum, Fixnum, Fixnum, [Hash, NilClass], Array,
      ::SolarSystem::Metadatas

    @solar_system_id = solar_system_id
    @player_ids = players.map(&:id)
    @metadatas = players.each_with_object({}) do |player, hash|
      hash[player.id] = metadatas.for_created(
        solar_system_id, player.id, player.friendly_ids, player.alliance_ids,
        x, y, kind, player_minimal
      )
    end
  end
end