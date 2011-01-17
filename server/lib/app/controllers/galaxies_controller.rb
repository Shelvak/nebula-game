class GalaxiesController < GenericController
  # Show galaxy for current player.
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
  # - units (Hash[]): Unit#as_json with :perspective
  # - players (Hash): Player#minimal_from_objects. Used to show to
  # whom units belong.
  # - route_hops (RouteHop[])
  # - fow_entries (FowGalaxyEntry[]): Fog of War galaxy entries for player
  # - wreckages (Wreckage[]): Wreckage#as_json
  #
  ACTION_SHOW = 'galaxies|show'

  def invoke(action)
    case action
    when ACTION_SHOW
      player = self.player
      fow_entries = FowGalaxyEntry.for(player)
      units = Galaxy.units(player, fow_entries)

      route_hops = RouteHop.find_all_for_player(player,
        player.galaxy, units)
      resolver = StatusResolver.new(player)
      respond :solar_systems => SolarSystem.visible_for(player),
        :units => units.map {
          |unit| unit.as_json(:perspective => resolver) },
        :players => Player.minimal_from_objects(units),
        :route_hops => route_hops,
        :fow_entries => fow_entries,
        :wreckages => Wreckage.by_fow_entries(fow_entries)
    end
  end
end
