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
    if from_solar_system
      message['from_solar_system'] = from_solar_system.travel_attrs
      if through
        raise GameLogicError.new(
          "through point (#{through.inspect
            }) is not in same solar system as from point (#{source.inspect
            })!"
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

    target_solar_system = target.solar_system
    if target_solar_system
      message['to_solar_system'] = target_solar_system.travel_attrs
      message['to_jumpgate'] = SolarSystem.rand_jumpgate(
        target_solar_system.id
      ).route_attrs
    end

    command(message)['locations']
  end

  protected
  def initialize_mule
    @mule = self.class.run("mule")
  end

  def command(message)
    json = message.to_json
    LOGGER.debug("[SpaceMule] Issuing message: #{json}")
    @mule.write json
    @mule.write "\n"
    response = @mule.readline.strip
    LOGGER.debug("[SpaceMule] Received answer: #{json}")
    JSON.parse(response)
  rescue Errno::EPIPE, EOFError => ex
    # Java crashed, restart it for next request.
    LOGGER.error("SpaceMule has crashed, restarting! #{ex.inspect}")
    initialize_mule
    # Notify that something went wrong
    raise ArgumentError.new("Message #{message.inspect} crashed SpaceMule!")
  end
end
