class GalaxiesController < GenericController
  ACTION_SHOW = 'galaxies|show'
  # Show galaxy for current player.
  #
  # Invocation: by server
  #
  # Parameters: None.
  #
  # Response:
  # - galaxy_id (Fixnum): ID of current galaxy
  # - solar_systems (Hash[]): Array of of such hashes:
  #   {
  #     :solar_system => +SolarSystem+,
  #     :metadata => FowSsEntry#merge_metadata
  #   }
  # - battleground_id (Fixnum): ID of battleground solar system
  # - units (Hash[]): Unit#as_json with :perspective
  # - players (Hash): Player#minimal_from_objects. Used to show to
  # whom units belong.
  # - non_friendly_routes (Route#as_json[]): Array of non-friendly
  # (NAP and enemy) routes which are in visible areas of the galaxy. #as_json
  # is called in :enemy mode.
  # - route_hops (RouteHop[])
  # - fow_entries (FowGalaxyEntry[]): Fog of War galaxy entries for player
  # - wreckages (Wreckage[]): Wreckage#as_json
  # - cooldowns (Cooldown[]): Cooldown#as_json
  #
  def action_show
    only_push!
    
    player = self.player
    fow_entries = FowGalaxyEntry.for(player)
    units = Galaxy.units(player, fow_entries)

    route_hops = RouteHop.find_all_for_player(player,
      player.galaxy, units)
    resolver = StatusResolver.new(player)
    respond \
      :galaxy_id => player.galaxy_id,
      :solar_systems => SolarSystem.visible_for(player).as_json,
      :battleground_id => Galaxy.battleground_id(player.galaxy_id),
      :units => units.map {
        |unit| unit.as_json(:perspective => resolver) },
      :players => Player.minimal_from_objects(units),
      :non_friendly_routes => Route.non_friendly_for_galaxy(
        fow_entries, player.friendly_ids
      ).map { |r| r.as_json(:mode => :enemy) },
      :route_hops => route_hops.map(&:as_json),
      :fow_entries => fow_entries.map(&:as_json),
      :wreckages => Wreckage.by_fow_entries(fow_entries).map(&:as_json),
      :cooldowns => Cooldown.by_fow_entries(fow_entries).map(&:as_json)
  end
end
