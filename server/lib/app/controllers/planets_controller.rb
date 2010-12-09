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
  # - players (Hash): Player#minimal_from_objects. Used to show to
  # whom units belong.
  # - npc_units (Unit[]): NPC units
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
  # Sends an exploration mission to explore block foliage.
  # 
  # You must have a research center to be able to explore something on a 
  # planet.
  # 
  # Invocation: By client
  # 
  # Parameters:
  # - planet_id (Fixnum)
  # - x (Fixnum): x of foliage start
  # - y (Fixnum): y of foliage end
  #
  ACTION_EXPLORE = 'planets|explore'

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
            : [],
          :units => planet.units.map {
            |unit| unit.as_json(:perspective => resolver)},
          :players => Player.minimal_from_objects(planet.units)
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
    when ACTION_EXPLORE
      param_options :required => %w{planet_id x y}

      planet = SsObject::Planet.where(:player_id => player.id).find(
        params['planet_id'])

      raise GameLogicError.new(
        "You must have at least on research center to be able to explore!"
      ) if Building::ResearchCenter.where(
        :planet_id => planet.id
      ).count == 0

      planet.explore!(params['x'], params['y'])
    end
  end
end