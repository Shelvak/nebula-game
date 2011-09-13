lambda do
  jar_path = File.join(ROOT_DIR, 'vendor', 'SpaceMule', 'dist', 'SpaceMule.jar')

  # Win32 requires us to manually require all the jars before requiring
  # main jar.
  Dir[File.dirname(jar_path) + "/lib/*.jar"].each { |jar| require jar }
  require jar_path

  # Scala <-> Ruby interoperability.
  class Object
    def to_scala
      case self
      when Hash
        scala_hash = Java::scala.collection.immutable.HashMap.new
        each do |key, value|
          scala_hash = scala_hash.updated(key.to_scala, value.to_scala)
        end
        scala_hash
      when Set
        scala_set = Java::scala.collection.immutable.HashSet.new
        each { |item| scala_set = scala_set.send(:"$plus", item.to_scala) }
        scala_set
      when Array
        scala_array = Java::scala.collection.mutable.ArrayBuffer.new
        each { |value| scala_array.send(:"$plus$eq", value.to_scala) }
        scala_array.to_indexed_seq
      when Symbol
        to_s
      else
        self
      end
    end

    def from_scala
      case self
      when Java::scala.collection.Map, Java::scala.collection.immutable.Map,
          Java::scala.collection.mutable.Map
        ruby_hash = {}
        foreach { |tuple| ruby_hash[tuple._1.from_scala] = tuple._2.from_scala }
        ruby_hash
      when Java::scala.collection.Set, Java::scala.collection.immutable.Set,
          Java::scala.collection.mutable.Set
        ruby_set = Set.new
        foreach { |item| ruby_set.add item.from_scala }
        ruby_set
      when Java::scala.collection.Seq
        ruby_array = []
        foreach { |item| ruby_array.push item.from_scala }
        ruby_array
      else
        self
      end
    end
  end

  module Kernel
    def Some(value); Java::scala.Some.new(value); end
    None = Java::spacemule.helpers.JRuby.None
  end
end.call

# Heavy work mule written in Java.
class SpaceMule
  include Singleton

  # Scala constants
  SmModules = Java::spacemule.modules

  Pmg = SmModules.pmg
  Coords = Pmg.classes.geom.Coords

  Pf = SmModules.pathfinder
  PfO = Pf.objects

  class Crash < RuntimeError; end

  def restart!
    send_config
  end

  def initialize
    initialize_mule
  end

  # Create a new galaxy with battleground solar system. Returns id of that
  # galaxy.
  def create_galaxy(ruleset, callback_url)
    Pmg.Runner.create_galaxy(ruleset, callback_url)
  end

  # Create a new players in _galaxy_id_. _players_ is a +Hash+ of
  # {auth_key => player_name} pairs.
  def create_players(galaxy_id, ruleset, players)
    Player.where(
      :galaxy_id => galaxy_id, :auth_token => players.keys
    ).all.each { |player| players.delete player.auth_token }

    Pmg.Runner.create_players(ruleset, galaxy_id, players.to_scala).from_scala \
      if players.size > 0
  end

  # Sends message to space mule for combat simulation.
  #
  # Input:
  #   * Map(
  #   *   "location" -> Map(
  #   *     "id" -> Int,
  #   *     "kind" -> Int,
  #   *     "x" -> Int | null
  #   *     "y" -> Int | null
  #   *   ),
  #   *   "planet_owner_id" -> Int | null,
  #   *   "nap_rules" -> Map[allianceId: Int -> napIds: Seq[Int]],
  #   *   "alliance_names" -> Map[allianceId: Int -> name: String]
  #   *   "players" -> Map[
  #   *     Int -> Map(
  #   *       "alliance_id" -> Int | null,
  #   *       "name" -> String,
  #   *       "damage_tech_mods" -> Map(
  #   *         "Unit::Trooper" -> Double,
  #   *         ...
  #   *       ),
  #   *       "armor_tech_mods" -> Map(
  #   *         "Unit::Trooper" -> Double,
  #   *         ...
  #   *       )
  #   *     )
  #   *   ],
  #   *   "troops" -> Seq[
  #   *     // This is Troop
  #   *     Map(
  #   *       "id" -> Int,
  #   *       "type" -> String,
  #   *       "level" -> Int,
  #   *       "hp" -> Int,
  #   *       "flank" -> Int,
  #   *       "player_id" -> Int | null,
  #   *       "stance" -> Int,
  #   *       "xp" -> Int
  #   *     )
  #   *   ],
  #   *   "loaded_troops" -> Map[transporterId: Int, Troop],
  #   *   "unloaded_troop_ids" -> Seq[Int],
  #   *   "buildings" -> Seq[
  #   *     Map(
  #   *       "id" -> Int,
  #   *       "type" -> String,
  #   *       "hp" -> Int,
  #   *       "level" -> Int
  #   *     )
  #   *   ]
  #   * )
  def combat(location, planet_owner_id, nap_rules, alliance_names, players,
      troops, loaded_troops, unloaded_unit_ids, buildings)
    message = {
      'action' => 'combat',
      'location' => location,
      'planet_owner_id' => planet_owner_id,
      'nap_rules' => nap_rules,
      'alliance_names' => alliance_names,
      'players' => players,
      'troops' => troops,
      'loaded_troops' => loaded_troops,
      "unloaded_troop_ids" => unloaded_unit_ids,
      'buildings' => buildings
    }

    LOGGER.block("Issuing combat to SpaceMule") do
      command(message)
    end
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
    avoidable_points = []

    source_solar_system = source.solar_system
    sm_source_solar_system = None
    if source_solar_system
      sm_source_solar_system = to_pf_solar_system(source_solar_system)

      if avoid_npc
        avoidable_points += source_solar_system.npc_unit_locations.map do
          |solar_system_point|
          
          PfO.SolarSystemPoint.new(
            sm_source_solar_system,
            Coords.new(solar_system_point.x, solar_system_point.y)
          )
        end
      end
    end

    target_solar_system = target.solar_system
    sm_target_solar_system = None
    if target_solar_system
      sm_target_solar_system = to_pf_solar_system(target_solar_system)

      if avoid_npc && source_solar_system != target_solar_system
        avoidable_points += target_solar_system.npc_unit_locations.map do
          |solar_system_point|

          PfO.SolarSystemPoint.new(
            sm_target_solar_system,
            Coords.new(solar_system_point.x, solar_system_point.y)
          )
        end
      end
    end

    # Add avoidable points if we have something to avoid.
    sm_avoidable_points = avoidable_points.blank? \
      ? None : Some(avoidable_points.to_scala)

    sm_source_jumpgates = Set.new.to_scala
    sm_target_jumpgates = Set.new.to_scala
    sm_source_ss_galaxy_coords = None
    sm_target_ss_galaxy_coords = None

    if source_solar_system && target.is_a?(GalaxyPoint)
      # SS -> Galaxy hop, only source JGs needed.
      sm_source_jumpgates = jumpgates_for(sm_source_solar_system)
      sm_source_ss_galaxy_coords =
        Some(jump_coords(target.id, target, source_solar_system))
    elsif source.is_a?(GalaxyPoint) && target_solar_system
      # Galaxy -> SS hop, only target JGs needed
      sm_target_jumpgates = jumpgates_for(sm_target_solar_system)
      sm_target_ss_galaxy_coords =
        Some(jump_coords(source.id, source, target_solar_system))
    elsif source_solar_system && target_solar_system && (
      source_solar_system.id != target_solar_system.id
    )
      # Different SS -> SS hop, we need all jumpgates
      sm_source_jumpgates = jumpgates_for(sm_source_solar_system)
      sm_target_jumpgates = jumpgates_for(sm_target_solar_system)

      sm_source_ss_galaxy_coords = Some(jump_coords(
        target_solar_system.galaxy_id, target_solar_system,
        source_solar_system
      ))
      sm_target_ss_galaxy_coords = Some(jump_coords(
        source_solar_system.galaxy_id, source_solar_system,
        target_solar_system
      ))
    else
      # No jumpgates needed.
    end

    sm_source = to_pf_locatable(source, sm_source_solar_system)
    sm_target = to_pf_locatable(target, sm_target_solar_system)

    puts [sm_source, sm_source_jumpgates, sm_source_solar_system,
      sm_source_ss_galaxy_coords,

      sm_target, sm_target_jumpgates, sm_target_solar_system,
      sm_target_ss_galaxy_coords,

      sm_avoidable_points].inspect
    PfO.Finder.find(
      sm_source, sm_source_jumpgates, sm_source_solar_system,
      sm_source_ss_galaxy_coords,

      sm_target, sm_target_jumpgates, sm_target_solar_system,
      sm_target_ss_galaxy_coords,

      sm_avoidable_points
    ).from_scala
  end

  protected
  # Converts Ruby +SolarSystem+ to SpaceMule +SolarSystem+ used in pathfinder.
  def to_pf_solar_system(solar_system)
    PfO.SolarSystem.new(
      solar_system.id,
      solar_system.x.nil? || solar_system.y.nil? \
        ? None \
        : Some(Coords.new(solar_system.x, solar_system.y)),
      solar_system.galaxy_id
    )
  end

  # Converts Ruby +Location+ to SpaceMule pathfinders +Locatable+.
  # _sm_solar_system_ is used if _location_ is in solar system.
  def to_pf_locatable(location, sm_solar_system)
    coords = Coords.new(location.x, location.y)
    case location
    when GalaxyPoint
      PfO.GalaxyPoint.new(location.id, coords, 1.0)
    when SolarSystemPoint
      PfO.SolarSystemPoint.new(sm_solar_system, coords)
    when SsObject
      PfO.Planet.new(location.id, sm_solar_system, coords)
    else
      raise ArgumentError.new(
        "Cannot convert #{location.inspect} to pathfinder Locatable!"
      )
    end
  end

  # Checks if _solar_system_ is a battleground. If so - links entry/exit
  # point to closest wormhole in the galaxy.
  #
  # Otherwise travels as expected.
  def jump_coords(galaxy_id, wormhole_proximity_point, solar_system)
    if solar_system.main_battleground?
      wormhole = Galaxy.closest_wormhole(galaxy_id,
        wormhole_proximity_point.x, wormhole_proximity_point.y)
      Coords.new(wormhole.x, wormhole.y)
    else
      Coords.new(solar_system.x, solar_system.y)
    end
  end

  # Given PmO.SolarSystem returns Set of +PmO.SolarSystemPoint+s.
  def jumpgates_for(sm_solar_system)
    points = SsObject::Jumpgate.where(:solar_system_id => sm_solar_system.id).
      all.map do |jumpgate|
        PfO.SolarSystemPoint.new(
          sm_solar_system,
          Coords.new(jumpgate.x, jumpgate.y)
        )
      end
    Set.new(points).to_scala
  end

  def initialize_mule
    LOGGER.block "Initializing SpaceMule", :level => :info do
      send_config
    end
    true
  end

  def send_config
    LOGGER.info "Sending configuration"
    # Suppress huge configuration. No need to have it in logs.
    LOGGER.suppress(:debug) do
      SmModules.config.Runner.run(
        USED_DB_CONFIG.to_scala,
        CONFIG.full_set_values.to_scala
      )
    end
  end
end