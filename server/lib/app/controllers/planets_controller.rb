class PlanetsController < GenericController
  # Show planet map.
  #
  # Parameters:
  #   `id` - planet_id
  #
  # Return:
  # - planet (SsObject): planet data
  # - tiles (Array): planet tiles
  # - buildings (Building[]): planet buildings
  # - foliages (Array): list of 1x1 foliages (like flowers and trees)
  # - units (Hash[]): Unit#as_json with :perspective
  # - npc_untis (Unit[]): NPC units
  #
  ACTION_SHOW = 'planets|show'
  # Sends a list of planets player currently owns.
  #
  # Invocation: Only push
  # pushed after galaxies|select
  #
  # Parameters: none
  #
  # Response:
  # - planets (SsObject::Planet[])
  #
  ACTION_PLAYER_INDEX = 'planets|player_index'

  def invoke(action)
    case action
    when ACTION_SHOW
      param_options :required => %w{id}

      planet = SsObject::Planet.find(params['id'])

      if planet.observer_player_ids.include?(player.id)
        self.current_ss_id = planet.solar_system_id
        self.current_planet_id = planet.id

        resolver = StatusResolver.new(player)
        respond \
          :planet => planet.as_json(
            :resources => planet.can_view_resources?(player.id),
            :view => true
          ),
          :tiles => Tile.fast_find_all_for_planet(planet),
          :folliages => Folliage.fast_find_all_for_planet(planet),
          :buildings => planet.buildings,
          :npc_units => planet.can_view_npc_units?(player.id) \
            ? Unit.garrisoned_npc_in(planet) \
            : {},
          :units => planet.units.map {
            |unit| unit.as_json(:perspective => resolver)}
      else
        raise GameLogicError.new(
          "Player #{player} cannot view this #{planet}!"
        )
      end
    when ACTION_PLAYER_INDEX
      only_push!
      planets = SsObject::Planet.for_player(player).map do
        |planet|
        planet.as_json(:resources => true)
      end
      respond :planets => planets
    end
  end
end