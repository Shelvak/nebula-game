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
    @solar_system_ids = Set.new(solar_system_ids)
  end

  # Returns +SolarSystemMetadata+ for solar system which is being created from
  # clients perspective.
  #
  # @param [Fixnum] solar_system_id ID of solar system
  # @param [Fixnum] player_id ID of player from whose perspective this metadata
  # is being generated.
  # @param [Array] friendly_ids friendly IDs for former player
  # @param [Array] alliance_ids alliance IDs for former player
  # @param [Fixnum] x X of solar system
  # @param [Fixnum] y Y of solar system
  # @param [Fixnum] kind kind of solar system
  # @param [Fixnum] player_minimal minimal representation of solar system owner.
  # Can be nil.
  # @return [SolarSystemMetadata]
  def for_created(
    solar_system_id, player_id, friendly_ids, alliance_ids,
    x, y, kind, player_minimal
  )
    SolarSystemMetadata.new(
      id: solar_system_id,
      x: x, y: y, kind: kind, player: player_minimal,
      player_planets: player_planets?(solar_system_id, player_id),
      player_ships: player_ships?(solar_system_id, player_id),
      enemies_with_planets: enemies_with_planets(solar_system_id, friendly_ids),
      enemies_with_ships: enemies_with_ships(solar_system_id, friendly_ids),
      allies_with_planets: allies_with_planets(solar_system_id, alliance_ids),
      allies_with_ships: allies_with_ships(solar_system_id, alliance_ids),
      # TODO: nap support
      naps_with_planets: [],
      naps_with_ships: []
    )
  end

  # Returns +SolarSystemMetadata+ for solar system which is existing from
  # clients perspective.
  #
  # @param [Fixnum] solar_system_id ID of solar system
  # @param [Fixnum] player_id ID of player from whose perspective this metadata
  # is being generated.
  # @param [Array] friendly_ids friendly IDs for former player
  # @param [Array] alliance_ids alliance IDs for former player
  # @return [SolarSystemMetadata]
  def for_existing(solar_system_id, player_id, friendly_ids, alliance_ids)
    SolarSystemMetadata.existing(
      solar_system_id,
      player_planets: player_planets?(solar_system_id, player_id),
      player_ships: player_ships?(solar_system_id, player_id),
      enemies_with_planets: enemies_with_planets(solar_system_id, friendly_ids),
      enemies_with_ships: enemies_with_ships(solar_system_id, friendly_ids),
      allies_with_planets: allies_with_planets(solar_system_id, alliance_ids),
      allies_with_ships: allies_with_ships(solar_system_id, alliance_ids),
      # TODO: nap support
      naps_with_planets: [],
      naps_with_ships: []
    )
  end

  # Returns +SolarSystemMetadata+ for solar system which is destroyed from
  # clients perspective.
  #
  # @param [Fixnum] solar_system_id ID of solar system
  # @return [SolarSystemMetadata]
  def for_destroyed(solar_system_id)
    SolarSystemMetadata.destroyed(solar_system_id)
  end

  # Does player with _player_id_ has planets in _solar_system_id_?
  def player_planets?(solar_system_id, player_id)
    player?(@sso_metas, solar_system_id, player_id)
  end

  # Does player with _player_id_ has ships in _solar_system_id_?
  def player_ships?(solar_system_id, player_id)
    player?(@unit_metas, solar_system_id, player_id)
  end

  # Returns array of enemy Player#minimal which have planets in
  # _solar_system_id_. _friendly_ids_ is a list of player ids friendly to
  # requesting player (including its id).
  def enemies_with_planets(solar_system_id, friendly_ids)
    enemies(@sso_metas, solar_system_id, friendly_ids)
  end

  # Returns array of enemy Player#minimal which have ships in
  # _solar_system_id_. _friendly_ids_ is a list of player ids friendly to
  # requesting player (including its id).
  def enemies_with_ships(solar_system_id, friendly_ids)
    enemies(@unit_metas, solar_system_id, friendly_ids)
  end

  # Returns array of ally Player#minimal which have planets in
  # _solar_system_id_. _alliance_ids_ is a list of player ids friendly to
  # requesting player (excluding its id).
  def allies_with_planets(solar_system_id, alliance_ids)
    alliance(@sso_metas, solar_system_id, alliance_ids)
  end

  # Returns array of ally Player#minimal which have ships in
  # _solar_system_id_. _alliance_ids_ is a list of player ids friendly to
  # requesting player (excluding its id).
  def allies_with_ships(solar_system_id, alliance_ids)
    alliance(@unit_metas, solar_system_id, alliance_ids)
  end

private

  def player?(storage, solar_system_id, player_id)
    check_ss_id!(solar_system_id)
    !! storage[solar_system_id].try(:include?, player_id)
  end

  def enemies(storage, solar_system_id, friendly_ids)
    check_ss_id!(solar_system_id)
    all_players = storage[solar_system_id] || Set.new
    (all_players - friendly_ids).map { |enemy_id| @players[enemy_id] }
  end

  def alliance(storage, solar_system_id, alliance_ids)
    check_ss_id!(solar_system_id)
    all_players = storage[solar_system_id] || Set.new
    (all_players & alliance_ids).map { |ally_id| @players[ally_id] }
  end

  def check_ss_id!(solar_system_id)
    raise ArgumentError, "Unknown solar system id #{solar_system_id}, only #{
      @solar_system_ids} were requested." \
      unless @solar_system_ids.include?(solar_system_id)
  end
end