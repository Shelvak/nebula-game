class PlanetsController < GenericController
  # Show all planets belonging to solar system.
  #
  # Invocation: by client
  #
  # Parameters:
  # - solar_system_id (Fixnum): solar system ID.
  #
  # Response:
  # - solar_system (SolarSystem)
  # - planets (SsObject[])
  # - units (Hash[]): Units wrapped with their statuses from
  # StatusResolver#resolve_objects.
  # - route_hops (RouteHop[]): Array of hop objects. It will include all
  # of your route hops in this solar system and one route hop for every
  # enemy unit
  #
  ACTION_INDEX = 'planets|index'
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
  # - units (Hash[]): Units wrapped with their statuses from
  # StatusResolver#resolve_objects.
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
  #   planets - Array of SsObject
  #
  ACTION_PLAYER_INDEX = 'planets|player_index'

  def invoke(action)
    case action
    when ACTION_INDEX
      param_options :required => %w{solar_system_id}

      # Client needs solar system to determine it's variation
      solar_system, metadata = SolarSystem.single_visible_for(
        params['solar_system_id'],
        player
      )
      old_ss_id = self.current_ss_id
      self.current_ss_id = solar_system.id
      self.current_planet_id = nil if old_ss_id != solar_system.id

      planets = SsObject.find(:all,
        :conditions => {:solar_system_id => solar_system.id},
        :include => :player)
      if FowSsEntry.can_view_units?(metadata)
        units = Unit.in_zone(solar_system)
        route_hops = RouteHop.find_all_for_player(
          player, solar_system, units
        )
        units = StatusResolver.new(player).resolve_objects(
          units
        )
      else
        units = []
        route_hops = []
      end

      respond :solar_system => solar_system,
        :planets => planets,
        :units => units,
        :route_hops => route_hops
    when ACTION_SHOW
      param_options :required => %w{id}

      planet = SsObjectSsObject.find(params['id'])

      if planet.observer_player_ids.include?(player.id)
        self.current_ss_id = planet.solar_system_id
        self.current_planet_id = planet.id
        
        respond :planet => planet,
          :tiles => Tile.fast_find_all_for_planet(planet),
          :folliages => Folliage.fast_find_all_for_planet(planet),
          :buildings => planet.buildings,
          :units => StatusResolver.new(player).resolve_objects(planet.units)
        
        push ResourcesController::ACTION_INDEX,
          'resources_entry' => planet.resources_entry \
          if planet.player and \
            planet.player.friendly_ids.include?(player.id)
      else
        raise GameLogicError.new(
          "Player #{player} cannot view this #{planet}!"
        )
      end
    when ACTION_PLAYER_INDEX
      only_push!
      respond :planets => SsObjectSsObjectSsObject.for_player(player)
    end
  end
end