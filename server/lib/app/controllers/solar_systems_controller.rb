class SolarSystemsController < GenericController
  # Show solar system.
  #
  # Invocation: by client
  #
  # Parameters:
  # - id (Fixnum): solar system ID.
  #
  # Response:
  # - solar_system (SolarSystem)
  # - ss_objects (SsObject[]): Look to SsObject#as_json,
  # SsObject::Planet#as_json and SsObject::Asteroid#as_json documentation.
  # - units (Hash[]): Units wrapped with their statuses from
  # StatusResolver#resolve_objects.
  # - route_hops (RouteHop[]): Array of hop objects. It will include all
  # of your route hops in this solar system and one route hop for every
  # enemy unit
  #
  ACTION_SHOW = 'solar_systems|show'

  def invoke(action)
    case action
    when ACTION_SHOW
      param_options :required => %w{id}

      # Client needs solar system to determine it's variation
      solar_system, metadata = SolarSystem.single_visible_for(
        params['id'],
        player
      )
      old_ss_id = self.current_ss_id
      self.current_ss_id = solar_system.id
      self.current_planet_id = nil if old_ss_id != solar_system.id

      resolver = StatusResolver.new(player)

      ss_objects = solar_system.ss_objects.includes(:player).map do 
        |ss_object|
        case ss_object
        when SsObject::Planet
          ss_object.as_json(
            :resources => ss_object.can_view_resources?(player.id),
            :perspective => resolver
          )
        when SsObject::Asteroid
          ss_object.as_json(
            :resources => FowSsEntry.can_view_details?(metadata)
          )
        else
          ss_object.as_json
        end
      end
      
      if FowSsEntry.can_view_details?(metadata)
        units = Unit.in_zone(solar_system)
        route_hops = RouteHop.find_all_for_player(
          player, solar_system, units
        )
      else
        units = []
        route_hops = []
      end

      respond :solar_system => solar_system,
        :ss_objects => ss_objects,
        :units => units.map {
          |unit| unit.as_json(:perspective => resolver) },
        :route_hops => route_hops
    end
  end
end