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
  # - units (Hash[]): Unit#as_json with :perspective
  # - players (Hash): Player#minimal_from_objects. Used to show to
  # whom units belong.
  # - non_friendly_routes (Route#as_json[]): Array of non-friendly
  # (NAP and enemy) routes which are in this solar system. #as_json
  # is called in :enemy mode.
  # - route_hops (RouteHop[]): Array of hop objects. It will include all
  # of your route hops in this solar system and one route hop for every
  # enemy unit
  # - wreckages (Wreckage[]): Wreckage#as_json
  # - cooldowns (Cooldown[]): Cooldown#as_json
  #
  def action_show
    param_options :required => %w{id}

    # Client needs solar system to determine it's variation
    solar_system = SolarSystem.find_if_visible_for(params['id'], player)
    solar_system = SolarSystem.galaxy_battleground(player.galaxy_id) \
      if solar_system.wormhole?

    # Only change planet if client opened other solar system.
    if self.current_planet_ss_id != solar_system.id
      self.current_planet_id = nil
      self.current_planet_ss_id = nil
    end
    self.current_ss_id = solar_system.id

    resolver = StatusResolver.new(player)

    ss_objects = solar_system.ss_objects.includes(:player).map do
      |ss_object|
      case ss_object
      when SsObject::Planet
        ss_object.as_json(:perspective => resolver)
      else
        ss_object.as_json
      end
    end

    units = Unit.in_zone(solar_system)
    route_hops = RouteHop.find_all_for_player(
      player, solar_system, units
    )

    respond :solar_system => solar_system,
      :ss_objects => ss_objects,
      :units => units.map {
        |unit| unit.as_json(:perspective => resolver)
      },
      :players => Player.minimal_from_objects(units),
      :non_friendly_routes => Route.non_friendly_for_solar_system(
        solar_system.id, player.friendly_ids
      ).map { |r| r.as_json(:mode => :enemy) },
      :route_hops => route_hops.map(&:as_json),
      :wreckages => Wreckage.in_zone(solar_system).all.map(&:as_json),
      :cooldowns => Cooldown.in_zone(solar_system).all.map(&:as_json)
  end
end