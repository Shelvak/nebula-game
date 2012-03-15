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
  # - non_friendly_jumps_at (Hash): Hash of non-friendly
  # (NAP and enemy) Route#jumps_at in format of {Route#id => Route#jumps_at}.
  # - route_hops (RouteHop[]): Array of hop objects. It will include all
  # of your route hops in this solar system and one route hop for every
  # enemy unit
  # - wreckages (Wreckage[]): Wreckage#as_json
  # - cooldowns (Cooldown[]): Cooldown#as_json
  #
  ACTION_SHOW = 'solar_systems|show'

  SHOW_OPTIONS = logged_in + required(:id => Fixnum)
  # Not sure what scope this action should use. However it doesn't write
  # anything so it shouldn't be a big problem even if I am mistaken.
  def self.show_scope(m); scope.player(m.player); end
  def self.show_action(m)
    without_locking do
      # Client needs solar system to determine it's variation
      solar_system = SolarSystem.find_if_visible_for(m.params['id'], m.player)
      solar_system = SolarSystem.galaxy_battleground(m.player.galaxy_id) \
        if solar_system.wormhole?

      # Only change planet if client opened other solar system.
      if current_planet_ss_id(m) != solar_system.id
        set_current_planet_id(m, nil)
        set_current_planet_ss_id(m, nil)
      end
      set_current_ss_id(m, solar_system.id)

      resolver = StatusResolver.new(m.player)

      ss_objects = solar_system.ss_objects.includes(:player).map do
        |ss_object|
        case ss_object
        when SsObject::Planet
          ss_object.as_json(:perspective => resolver)
        else
          ss_object.as_json
        end
      end

      scope = Unit.in_zone(solar_system)

      # Non-moving & non-npc units.
      units = scope.
        where("player_id IS NOT NULL OR route_id IS NOT NULL")
      route_hops = RouteHop.find_all_for_player(
        player, solar_system, units
      )

      # Standing NPC units. This is needed because there can be even 4000 of them
      # and we need to get them as fast as we can.
      npc_units = Unit.fast_npc_fetch(
        scope.where(:player_id => nil, :route_id => nil)
      )

      units = Unit.in_zone(solar_system)
      route_hops = RouteHop.find_all_for_player(
        m.player, solar_system, units
      )

      respond m,
        :solar_system => solar_system,
        :ss_objects => ss_objects,
        :units => units.map {
          |unit| unit.as_json(:perspective => resolver)
        },
        :npc_units => npc_units, # TODO: spec me in s2_par branch!
        :players => Player.minimal_from_objects(units),
        :non_friendly_jumps_at => Route.jumps_at_hash_from_collection(
          Route.non_friendly_for_solar_system(
            solar_system.id, m.player.friendly_ids
          )
        ),
        :route_hops => route_hops.map(&:as_json),
        :wreckages => Wreckage.in_zone(solar_system).all.map(&:as_json),
        :cooldowns => Cooldown.in_zone(solar_system).all.map(&:as_json)
    end
  end
end