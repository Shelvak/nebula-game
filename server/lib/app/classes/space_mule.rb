# Heavy work mule written in Java.
class SpaceMule
  include Singleton
  JAR_PATH = File.join(ROOT_DIR, 'vendor', 'SpaceMule', 'dist',
    'SpaceMule.jar')

  def self.run
    IO.popen(
      'java -server -jar "%s" 2>&1' % SpaceMule::JAR_PATH,
      "w+"
    )
  end

  def restart!
    @mule.close
    initialize_mule
  end

  def initialize
    initialize_mule
  end

  # Create a new galaxy with battleground solar system. Returns id of that
  # galaxy.
  def create_galaxy(ruleset)
    command('action' => 'create_galaxy', 'ruleset' => ruleset)['id']
  end

  # Create a new players in _galaxy_id_. _players_ is a +Hash+ of
  # {auth_key => player_name} pairs.
  def create_players(galaxy_id, ruleset, players)
    Player.where(
      :galaxy_id => galaxy_id, :auth_token => players.keys
    ).all.each { |player| players.delete player.auth_token }

    if players.size > 0
      command('action' => 'create_players',
        'galaxy_id' => galaxy_id, 'ruleset' => ruleset,
        'players' => players)
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
  # Example output:
  # [
  #   {'id' => ..., 'type' => ..., 'x' => ..., 'y' => ...},
  #   ...
  # ]
  #
  def find_path(source, target, through=nil, avoid_npc=true)
    message = {
      'action' => 'find_path',
      'from' => source.route_attrs,
      'from_jumpgate' => nil,
      'from_solar_system' => nil,
      'from_ss_galaxy_coords' => nil,
      'to' => target.route_attrs,
      'to_jumpgate' => nil,
      'to_solar_system' => nil,
      'to_ss_galaxy_coords' => nil,
    }

    avoidable_points = []

    source_solar_system = source.solar_system
    if source_solar_system
      message['from_solar_system'] = source_solar_system.travel_attrs
      avoidable_points += source_solar_system.npc_unit_locations if avoid_npc
    end

    target_solar_system = target.solar_system
    if target_solar_system
      message['to_solar_system'] = target_solar_system.travel_attrs
      avoidable_points += target_solar_system.npc_unit_locations \
        if avoid_npc && source_solar_system != target_solar_system
    end

    # Add avoidable points if we have something to avoid.
    message['avoidable_points'] = avoidable_points \
      unless avoidable_points.blank?

    if source_solar_system && target.is_a?(GalaxyPoint)
      # SS -> Galaxy hop, only source JG needed.
      set_source_jg(message, source, source_solar_system, through)
      set_wormhole(message, 'from_ss_galaxy_coords', target.id, target,
        source_solar_system)
    elsif source.is_a?(GalaxyPoint) && target_solar_system
      # Galaxy -> SS hop, only target JG needed
      set_target_jg(message, target_solar_system, target)
      set_wormhole(message, 'to_ss_galaxy_coords', source.id, source,
        target_solar_system)
    elsif source_solar_system && target_solar_system && (
      source_solar_system.id != target_solar_system.id)
      # Different SS -> SS hop, we need both jumpgates
      set_source_jg(message, source, source_solar_system, through)
      set_target_jg(message, target_solar_system, target)

      set_wormhole(message, 'from_ss_galaxy_coords', 
        target_solar_system.galaxy_id,
        target_solar_system, source_solar_system)
      set_wormhole(message, 'to_ss_galaxy_coords',
        source_solar_system.galaxy_id,
        source_solar_system, target_solar_system)
    else
      # No jumpgates needed.
    end

    command(message)['locations']
  end

  protected
  # Checks if _solar_system_ is a battleground. If so - links entry/exit
  # point to closest wormhole in the galaxy.
  #
  # Otherwise travels as expected.
  def set_wormhole(message, name, galaxy_id, wormhole_proximity_point,
      solar_system)
    if solar_system.battleground?
      wormhole = Galaxy.closest_wormhole(galaxy_id, 
        wormhole_proximity_point.x, wormhole_proximity_point.y)
      message[name] = [wormhole.x, wormhole.y]
    else
      message[name] = [solar_system.x, solar_system.y]
    end
  end

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

  def set_target_jg(message, target_solar_system, target)
    message['to_jumpgate'] = SolarSystem.closest_jumpgate(
      target_solar_system.id,
      target.position,
      target.angle
    ).route_attrs
  end

  def initialize_mule
    LOGGER.block "Initializing SpaceMule", :level => :info do
      LOGGER.info "Loading SpaceMule"
      @mule = self.class.run
      LOGGER.info "Sending configuration"
      @full_sets ||= CONFIG.full_set_values

      # Suppress huge configuration. No need to have it in logs.
      LOGGER.suppress(:debug) do
        command({
          'action' => 'config',
          'db' => USED_DB_CONFIG,
          'sets' => @full_sets
        })
      end
    end
    true
  end

  def command(message)
    json = JSON.generate(message)
    LOGGER.debug("Issuing message: #{json}", "SpaceMule")
    @mule.write json
    @mule.write "\n"
    response = @mule.readline.strip
    LOGGER.debug("Received answer: #{response}", "SpaceMule")
    parsed = JSON.parse(response)
    if parsed["error"]
      raise EOFError
    else
      parsed
    end
  rescue Errno::EPIPE, EOFError, JSON::ParserError => ex
    # Java crashed, restart it for next request.
    error = response + @mule.read

    LOGGER.error("SpaceMule has crashed, restarting!

Java info:
#{error}

Ruby info:
#{ex.inspect}", "SpaceMule")
    initialize_mule
    # Notify that something went wrong
    raise ArgumentError.new("Message #{message.inspect} crashed SpaceMule!")
  end
end
