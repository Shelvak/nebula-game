class GalaxiesController < GenericController
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
  # - apocalypse_start (Time | nil): time of apocalypse start, if started.
  # - units (Hash[]): Unit#as_json with :perspective
  # - players (Hash): Player#minimal_from_objects. Used to show to
  # whom units belong.
  # - non_friendly_jumps_at (Hash): Hash of non-friendly
  # (NAP and enemy) Route#jumps_at in format of {Route#id => Route#jumps_at}.
  # - route_hops (RouteHop[])
  # - fow_entries (FowGalaxyEntry[]): Fog of War galaxy entries for player
  # - wreckages (Wreckage[]): Wreckage#as_json
  # - cooldowns (Cooldown[]): Cooldown#as_json
  #
  ACTION_SHOW = 'galaxies|show'

  SHOW_OPTIONS = logged_in + only_push
  def self.show_scope(m); scope.galaxy(m.player.galaxy_id); end
  def self.show_action(m)
    player = m.player
    fow_entries = FowGalaxyEntry.for(player)
    units = Galaxy.units(player, fow_entries)

    route_hops = RouteHop.find_all_for_player(player, player.galaxy, units)
    resolver = StatusResolver.new(player)
    respond m,
      :galaxy_id => player.galaxy_id,
      :solar_systems => SolarSystem.visible_for(player).as_json,
      :battleground_id => Galaxy.battleground_id(player.galaxy_id),
      :apocalypse_start => Galaxy.apocalypse_start(player.galaxy_id),
      :units => units.map { |unit| unit.as_json(:perspective => resolver) },
      :players => Player.minimal_from_objects(units),
      :non_friendly_jumps_at => Route.jumps_at_hash_from_collection(
        Route.non_friendly_for_galaxy(fow_entries, player.friendly_ids)
      ),
      :route_hops => route_hops.map(&:as_json),
      :fow_entries => fow_entries.map(&:as_json),
      :wreckages => Wreckage.by_fow_entries(fow_entries).map(&:as_json),
      :cooldowns => Cooldown.by_fow_entries(fow_entries).map(&:as_json)
  end

  # Notifies client that the apocalypse has started.
  #
  # Invocation: by server
  #
  # Parameters: Same as response.
  #
  # Response:
  # - start (Time): start date of apocalypse
  #
  ACTION_APOCALYPSE = 'galaxies|apocalypse'

  APOCALYPSE_OPTIONS = logged_in + only_push + required(:start => Time)
  def self.apocalypse_scope(m); scope.player(m.player); end
  def self.apocalypse_action(m)
    respond m, :start => m.params['start']
  end
end
