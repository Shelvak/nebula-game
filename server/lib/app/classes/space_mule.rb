# Heavy work mule written in Java.
class SpaceMule
  include Singleton
  JAR_PATH = File.join(ROOT_DIR, 'vendor', 'SpaceMule', 'dist',
    'SpaceMule.jar')

  def self.run(command)
    IO.popen(
      'java -jar "%s" "%s"' % [SpaceMule::JAR_PATH, command],
      "w+"
    )
  end

  def initialize
    initialize_mule
  end

  # Create a new players in _galaxy_id_. _players_ is a +Hash+ of
  # {player_id => auth_key} pairs.
  def create_players(galaxy_id, players)
    command('action' => 'create_players', 'galaxy_id' => galaxy_id,
      'players' => players)
  end

  # Finds traveling path from _source_ to _target_ and returns path.
  #
  # _source_ is object that responds to Location#route_attrs.
  # _target_ is object that responds to Location#route_attrs.
  # _through_ is +Planet::Jumpgate+.
  #
  # Example output:
  # [
  #   {'id' => ..., 'type' => ..., 'x' => ..., 'y' => ...},
  #   ...
  # ]
  #
  def find_path(source, target, through=nil)
    message = {
      'action' => 'find_path',
      'from' => source.route_attrs,
      'from_jumpgate' => nil,
      'from_solar_system' => nil,
      'to' => target.route_attrs,
      'to_jumpgate' => nil,
      'to_solar_system' => nil,
    }

    from_solar_system = source.solar_system
    message['from_solar_system'] = from_solar_system.travel_attrs \
      if from_solar_system

    target_solar_system = target.solar_system
    message['to_solar_system'] = target_solar_system.travel_attrs \
      if target_solar_system

    if from_solar_system && target.is_a?(GalaxyPoint)
      # SS -> Galaxy hop, only source JG needed.
      set_source_jg(message, source, from_solar_system, through)
    elsif source.is_a?(GalaxyPoint) && target_solar_system
      # Galaxy -> SS hop, only target JG needed
      set_target_jg(message, target_solar_system)
    elsif from_solar_system && target_solar_system && (
      from_solar_system.id != target_solar_system.id)
      # Different SS -> SS hop, we need both jumpgates
      set_source_jg(message, source, from_solar_system, through)
      set_target_jg(message, target_solar_system)
    else
      # No jumpgates needed.
    end      

    command(message)['locations']
  end

  protected
  def set_source_jg(message, source, from_solar_system, through)
    if through
      raise GameLogicError.new(
        "through point (#{through.inspect
          }) is not in same solar system as from point (#{source.inspect
          })!#"
      ) unless source.solar_system_id == through.solar_system_id

      message['from_jumpgate'] = through.route_attrs
    else
      message['from_jumpgate'] = SolarSystem.closest_jumpgate(
        from_solar_system.id,
        source.position,
        source.angle
      ).route_attrs
    end
  end

  def set_target_jg(message, target_solar_system)
    message['to_jumpgate'] = SolarSystem.rand_jumpgate(
      target_solar_system.id
    ).route_attrs
  end

  def initialize_mule
    @mule = self.class.run("mule")
    command(
      'action' => 'config',
      'db' => USED_DB_CONFIG,
      'sets' => CONFIG.full_set_values
    )
  end

  def command(message)
    json = message.to_json
    LOGGER.debug("Issuing message: #{json}", "SpaceMule")
    @mule.write json
    @mule.write "\n"
    response = @mule.readline.strip
    LOGGER.debug("Received answer: #{json}", "SpaceMule")
    JSON.parse(response)
  rescue Errno::EPIPE, EOFError => ex
    # Java crashed, restart it for next request.
    LOGGER.error("SpaceMule has crashed, restarting! #{ex.inspect}",
      "SpaceMule")
    initialize_mule
    # Notify that something went wrong
    raise ArgumentError.new("Message #{message.inspect} crashed SpaceMule!")
  end
end
