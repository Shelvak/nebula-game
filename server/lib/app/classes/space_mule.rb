# Heavy work mule written in Scala.
class SpaceMule
  include Singleton

  # Scala constants
  SmModules = Java::spacemule.modules
  Pmg = SmModules.pmg

  def initialize
    SmModules.config.Runner.run(
      USED_DB_CONFIG.to_scala,
      CONFIG.scala_wrapper
    )
  end

  # Create a new galaxy with battleground solar system. Returns id of that
  # galaxy.
  def create_galaxy(ruleset, callback_url)
    Pmg.Runner.create_galaxy(ruleset, callback_url)
  end

  # Create a new players in _galaxy_id_. _players_ is a +Hash+ of
  # {web_user_id => player_name} pairs.
  def create_players(galaxy_id, ruleset, players)
    PlayerCreator.invoke(galaxy_id, ruleset, players)
  end

  # Creates a new, empty zone with only non-player solar systems.
  def create_zone(galaxy_id, ruleset, slot, quarter)
    PlayerCreator.create_zone(galaxy_id, ruleset, slot, quarter)
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
    response = Combat.invoke(location, players, nap_rules, units, loaded_units,
                             unloaded_unit_ids, buildings)
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