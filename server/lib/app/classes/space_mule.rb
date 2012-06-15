require 'jruby'

# Heavy work mule written in Scala.
class SpaceMule
  include Singleton

  # Scala constants
  SmModules = Java::spacemule.modules
  Pmg = SmModules.pmg
  DB = Java::spacemule.persistence.DB

  def initialize
    Java::spacemule.helpers.JRuby.runtime = JRuby.runtime
    SmModules.config.objects.Config.data = GameConfig::ScalaWrapper.new
  end

  # Fill created galaxy with battleground solar system and ensure it has free
  # zones and home solar systems.
  def fill_galaxy(galaxy, free_zones, free_home_ss)
    typesig binding, Galaxy, Fixnum, Fixnum

    CONFIG.with_set_scope(galaxy.ruleset) do
      Pmg.Runner.fill_galaxy(
        galaxy.id, galaxy.ruleset, free_zones, free_home_ss
      )
    end
  end

  def ensure_pool(galaxy, max_zone_iterations=1, max_home_ss_iterations=10)
    typesig binding, Galaxy, Fixnum, Fixnum

    CONFIG.with_set_scope(galaxy.ruleset) do
      Pmg.Runner.ensurePool(
        galaxy.id, galaxy.ruleset,
        galaxy.pool_free_zones,
        max_zone_iterations,
        galaxy.pool_free_home_ss,
        max_home_ss_iterations
      )
    end
  end

  # Fetch pool stats for galaxy _galaxy_id_.
  #
  # Returns an object with two methods: #free_zones and #free_home_systems.
  def pool_stats(galaxy_id)
    Pmg.Runner.poolStats(galaxy_id)
  end

  # Sends message to space mule for combat simulation.
  #
  # _location_ is +Location+ object.
  # _players_ is Array of +Player+s.
  # _nap_rules_ is Hash received from Nap#get_rules
  # _units_ is Array of +Unit+s.
  # _loaded_units_ is Hash of {transporter_id => Set of +Unit+s}
  # _unloaded_unit_ids_ is Set[unit_id]
  # _buildings_ is Array of +Building+s.
  def combat(location, players, nap_rules, units, loaded_units,
             unloaded_unit_ids, buildings)
    response = Combat.invoke(
      location, players, nap_rules, units, loaded_units, unloaded_unit_ids,
      buildings
    )
    response.empty? ? nil : response.get
  end

  # Finds traveling path from _source_ to _target_ and returns path.
  #
  # _source_ is object that responds to Location#route_attrs.
  # _target_ is object that responds to Location#route_attrs.
  # _through_ is +SsObject::Jumpgate+.
  # _avoid_npc_ is +Boolean+ if we should try to avoid NPC units in
  # solar systems.
  #
  # Returns Array of PmO.ServerLocation:
  #   id: Int,
  #   kind: Location.Kind,
  #   coords: Option[Coords],
  #   timeMultiplier: Double
  #
  def find_path(source, target, avoid_npc=true)
    Pathfinder.invoke(source, target, avoid_npc)
  end
end