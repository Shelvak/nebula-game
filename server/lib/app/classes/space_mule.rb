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

# Heavy work mule written in Scala.
class SpaceMule
  include Singleton

  # Scala constants
  SmModules = Java::spacemule.modules
  Pmg = SmModules.pmg

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

  protected
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