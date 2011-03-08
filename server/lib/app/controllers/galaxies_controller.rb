class GalaxiesController < GenericController
  ACTION_SHOW = 'galaxies|show'
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
  # - battleground_id (Fixnum): ID of battleground solar system
  # - units (Hash[]): Unit#as_json with :perspective
  # - players (Hash): Player#minimal_from_objects. Used to show to
  # whom units belong.
  # - route_hops (RouteHop[])
  # - fow_entries (FowGalaxyEntry[]): Fog of War galaxy entries for player
  # - wreckages (Wreckage[]): Wreckage#as_json
  #
  def action_show
    player = self.player
    fow_entries = FowGalaxyEntry.for(player)
    units = Galaxy.units(player, fow_entries)

    route_hops = RouteHop.find_all_for_player(player,
      player.galaxy, units)
    resolver = StatusResolver.new(player)
    respond :solar_systems => SolarSystem.visible_for(player).as_json,
      :battleground_id => Galaxy.battleground_id(player.galaxy_id),
      :units => units.map {
        |unit| unit.as_json(:perspective => resolver) },
      :players => Player.minimal_from_objects(units),
      :route_hops => route_hops.map(&:as_json),
      :fow_entries => fow_entries.map(&:as_json),
      :wreckages => Wreckage.by_fow_entries(fow_entries).map(&:as_json)
  end
end
