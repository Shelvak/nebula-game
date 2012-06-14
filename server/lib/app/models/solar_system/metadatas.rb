# TODO: spec
class SolarSystem::Metadatas
  def initialize(solar_system_ids)
    solar_system_ids = Array(solar_system_ids)

    player_ids = Set.new

    @sso_metas = without_locking do
      SsObject.
        select("`solar_system_id`, `player_id`").
        where(solar_system_id: solar_system_ids).
        where("`player_id` IS NOT NULL").
        c_select_all
    end.each_with_object({}) do |row, hash|
      hash[row['solar_system_id']] ||= Set.new
      hash[row['solar_system_id']].add row['player_id']
      player_ids.add row['player_id']
    end

    @unit_metas = without_locking do
      Unit.
        select("`location_solar_system_id`, `player_id`").
        where(location_solar_system_id: solar_system_ids).
        where("`player_id` IS NOT NULL").
        c_select_all
    end.each_with_object({}) do |row, hash|
      hash[row['location_solar_system_id']] ||= Set.new
      hash[row['location_solar_system_id']].add row['player_id']
      player_ids.add row['player_id']
    end

    @players = Player.minimal_from_ids(player_ids.to_a)
  end

  def player_planets?(solar_system_id, player_id)
    player?(@sso_metas, solar_system_id, player_id)
  end

  def player_ships?(solar_system_id, player_id)
    player?(@unit_metas, solar_system_id, player_id)
  end

  def enemies_with_planets(solar_system_id, friendly_ids)
    enemies(@sso_metas, solar_system_id, friendly_ids)
  end

  def enemies_with_ships(solar_system_id, friendly_ids)
    enemies(@unit_metas, solar_system_id, friendly_ids)
  end

  def allies_with_planets(solar_system_id, alliance_ids)
    alliance(@sso_metas, solar_system_id, alliance_ids)
  end

  def allies_with_ships(solar_system_id, alliance_ids)
    alliance(@unit_metas, solar_system_id, alliance_ids)
  end

  # Returns +SolarSystemMetadata+ for solar system which is being created from
  # clients perspective.
  def for_created(
    solar_system_id, player_minimal, friendly_ids, alliance_ids,
    x, y, kind
  )
    player_id = player_minimal.try(:[], 'id')
    SolarSystemMetadata.new(
      id: solar_system_id,
      x: x, y: y, kind: kind, player: player_minimal,
      player_planets: player_planets?(solar_system_id, player_id),
      player_ships: player_ships?(solar_system_id, player_id),
      enemy_planets: enemies_with_planets(solar_system_id, friendly_ids),
      enemy_ships: enemies_with_ships(solar_system_id, friendly_ids),
      alliance_planets: allies_with_planets(solar_system_id, alliance_ids),
      alliance_ships: allies_with_ships(solar_system_id, alliance_ids),
      # TODO: nap support
      nap_planets: false,
      nap_ships: false
    )
  end

  # Returns +SolarSystemMetadata+ for solar system which is existing from
  # clients perspective.
  def for_existing(solar_system_id, player_id, friendly_ids, alliance_ids)
    SolarSystemMetadata.existing(
      solar_system_id,
      player_planets: player_planets?(solar_system_id, player_id),
      player_ships: player_ships?(solar_system_id, player_id),
      enemy_planets: enemies_with_planets(solar_system_id, friendly_ids),
      enemy_ships: enemies_with_ships(solar_system_id, friendly_ids),
      alliance_planets: allies_with_planets(solar_system_id, alliance_ids),
      alliance_ships: allies_with_ships(solar_system_id, alliance_ids),
      # TODO: nap support
      nap_planets: false,
      nap_ships: false
    )
  end

  # Returns +SolarSystemMetadata+ for solar system which is destroyed from
  # clients perspective.
  def for_destroyed(solar_system_id)
    SolarSystemMetadata.destroyed(solar_system_id)
  end

private

  def player?(storage, solar_system_id, player_id)
    storage[solar_system_id].try(:include?, player_id)
  end

  def enemies(storage, solar_system_id, friendly_ids)
    all_players = storage[solar_system_id] || Set.new
    (all_players - friendly_ids).map { |enemy_id| @players[enemy_id] }
  end

  def alliance(storage, solar_system_id, alliance_ids)
    all_players = storage[solar_system_id] || Set.new
    (all_players & alliance_ids).map { |ally_id| @players[ally_id] }
  end
end