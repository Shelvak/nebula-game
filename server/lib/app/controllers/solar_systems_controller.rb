class SolarSystemsController < GenericController
  # Show visible solar systems in galaxy for current player.
  #
  # Invocation: by client or by server
  #
  # Parameters: None.
  #
  # Response:
  # - solar_systems (Hash[]): Array of of such hashes:
  #   {
  #     :solar_system => +SolarSystem+, 
  #     :metadata => FowSsEntry#merge_metadata
  #   }
  # - units (Hash[]): Units wrapped in StatusResolver#resolve_objects
  # - route_hops (RouteHop[])
  # - fow_entries (FowGalaxyEntry[]): Fog of War galaxy entries for player
  #
  ACTION_INDEX = 'solar_systems|index'

  def invoke(action)
    case action
    when ACTION_INDEX
      units = Galaxy.units(player)
      route_hops = RouteHop.find_all_for_player(player,
        player.galaxy, units)
      units = StatusResolver.new(player).resolve_objects(units)

      respond :solar_systems => SolarSystem.visible_for(player),
        :units => units, :route_hops => route_hops,
        :fow_entries => FowGalaxyEntry.for(player)
    end
  end
end