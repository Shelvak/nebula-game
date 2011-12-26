RSpec::Matchers.define :be_created_from_static_ss_configuration do
  |configuration|

  def check_planet(position_str, ss_conditions, data)
    exp_to = "Expected planet @ #{position_str} to"
    if SsObject::Planet.where(ss_conditions).exists?
      planet = SsObject::Planet.where(ss_conditions).first

      owned_by_player = ! planet.player_id.nil?
      @errors << "#{exp_to} have owned_by_player: #{data["owned_by_player"]
        } but it was #{owned_by_player}." \
        if owned_by_player != data["owned_by_player"]

      @errors << "#{exp_to} have next_raid_at but it did not." \
        if planet.next_raid_at.nil?

      @errors << "#{exp_to} have raid_arg set to 0, but it was set to #{
        planet.raid_arg}" unless planet.raid_arg == 0

      @errors << "#{exp_to} have raid callback registered but it did not." \
        unless CallbackManager.has?(
          planet, CallbackManager::EVENT_RAID, planet.next_raid_at
        )

      planet_data = CONFIG["planet.map.#{data['map']}"][0]

      exp_width, exp_height = planet_data['size']
      @errors << "#{exp_to} be #{exp_width}x#{exp_height} but it was #{
        planet.width}x#{planet.height} instead" \
        if [planet.width, planet.height] != planet_data['size']

      @errors << "#{exp_to} have its name conforming to #{planet_data['name']
        } but its name was #{planet.name.inspect}" \
        unless planet.name.gsub(/\d+/, "%d") == planet_data['name']

      @errors << "#{exp_to} have terrain type #{planet_data['terrain']
        }, but it was #{planet.terrain}" \
        unless planet.terrain == planet_data['terrain']

      check_planet_starting_resources(exp_to, planet, planet_data)
      check_planet_tiles(exp_to, planet, planet_data['tiles'])
      check_planet_buildings(exp_to, planet, planet_data['buildings'],
                             position_str)
      check_units(
        planet_data['units'],
        LocationPoint.planet(planet.id),
        "planet (id: #{planet.id}) @ #{position_str}"
      )
    else
      @errors << "#{exp_to} exist but it did not."
    end
  end

  def check_planet_starting_resources(exp_to, planet, data)
    precision = 1.0

    Resources::TYPES.each_with_index do |type, index|
      actual = planet.send(type)
      expected = data['resources'][index]

      @errors << "#{exp_to} have resource #{type} within #{precision
        } of #{expected} but it was #{actual}." \
        unless actual.within?(expected, precision)
    end
  end

  def check_planet_tiles(exp_to, planet, tiles)
    tiles.each do |kind, coords|
      if kind == Tile::VOID
        rows = Tile.
          select("x, y").
          where(:planet_id => planet.id).
          where(coords.map { |x, y| "(x=#{x} AND y=#{y})" }.join(" OR ")).
          c_select_all

        @errors << "#{exp_to} have no tiles at #{
          rows.map { |r| "#{r['x']},#{r['y']}"}.join(', ')
        } but it did." if rows.size > 0
      else
        actual_coords = Tile.
          select("x, y").
          where(:planet_id => planet.id, :kind => kind).
          c_select_all.map { |row| [row['x'], row['y']] }

        extra_tiles = actual_coords - coords
        missing_tiles = coords - actual_coords

        @errors << "#{exp_to} have no extra tiles of #{Tile::MAPPING[kind]
          } but it did @ #{
            extra_tiles.map { |x, y| "#{x},#{y}"}.join(', ')
          }" if extra_tiles.size > 0
        @errors << "#{exp_to} not have any missing tiles of #{
          Tile::MAPPING[kind]} but it did @ #{
            missing_tiles.map { |x, y| "#{x},#{y}"}.join(', ')
          }" if missing_tiles.size > 0
      end
    end
  end

  def check_planet_buildings(exp_to, planet, buildings, position_str)
    buildings.each do |type, type_data|
      expected_data = type_data.map do |x, y, level, units|
        [x, y, level]
      end

      rows = Building.
        select("id, x, y, level").
        where(:planet_id => planet.id, :type => type).
        c_select_all
      rows_by_coords = rows.hash_by { |row| [row['x'], row['y']] }
      actual_data = rows.map { |row| [row['x'], row['y'], row['level']] }

      extra_buildings = actual_data - expected_data
      missing_buildings = expected_data - actual_data

      @errors << "#{exp_to} have no extra buildings of #{type
        } but it did @ #{
          extra_buildings.map { |x, y, l| "#{x},#{y}(lvl: #{l})"}.join(', ')
        }" if extra_buildings.size > 0
      @errors << "#{exp_to} not have any missing buildings of #{type
        } but it did @ #{
          missing_buildings.map { |x, y, l| "#{x},#{y}(lvl: #{l})"}.join(', ')
        }" if missing_buildings.size > 0

      type_data.each do |x, y, level, units|
        row = rows_by_coords[[x, y]]

        unless row.nil?
          location = LocationPoint.new(row['id'], Location::BUILDING, nil, nil)
          check_units(
            units, location,
            "Building #{type} (id: #{row['id']}) in planet (id: #{planet.id
              }) @ #{position_str}"
          )
        end
      end
    end
  end

  def check_asteroid(position_str, ss_conditions)
    row = SsObject::Asteroid.where(ss_conditions).
      select(
        Resources::TYPES.map { |t| "#{t}_generation_rate" }.join(", ")
      ).c_select_one

    if row.nil?
      @errors << "Expected asteroid to exist @ #{position_str
        } but it did not."
    else
      Resources::TYPES.each_with_index do |type, index|
        actual = row["#{type}_generation_rate"]
        expected = data["resources"][index]
        if actual != expected
          @errors << "Expected asteroid @ #{position_str} to have #{
            type} rate of #{expected} but it had rate of #{actual}."
        end
      end
    end
  end

  def check_jumpgate(position_str, ss_conditions)
    row = SsObject::Jumpgate.where(ss_conditions).select("id").
      c_select_value

    if row.nil?
      @errors << "Expected jumpgate to exist @ #{position_str
        } but it did not."
    end
  end

  def check_wreckage(wreckage_data, location)
    row = Wreckage.
      in_location(location).
      select(Resources::TYPES.join(", ")).
      c_select_one

    if row.nil?
      @errors << "Expected wreckage to exist @ #{location} but it did not."
    else
      Resources::TYPES.each_with_index do |type, index|
        actual = row[type.to_s]
        expected = wreckage_data[index]
        if actual != expected
          @errors << "Expected wreckage @ #{location
          } to have #{type} amount of #{expected} but it had #{actual}."
        end
      end
    end
  end

  def check_units(units_data, location, location_str=nil)
    location_str ||= location.to_s

    grouped = Unit.in_location(location).all.grouped_counts do |unit|
      # Can't use Unit#type because it RANDOMLY returns Unit#class instead
      # of actual #type attribute... Fuck that.
      [unit[:type], unit.flank, unit.hp_percentage]
    end

    #"units" => [[1, "dirac", 0, 1.0]]
    units_data.each do |expected_count, type, flank, hp_percentage|
      key = [type, flank, hp_percentage.to_f]
      actual_count = grouped.delete(key) || 0
      unless actual_count == expected_count
        @errors << "Expected to have #{expected_count} #{type} in flank #{
          flank} with #{hp_percentage * 100}% HP @ #{location_str
          }, but only had #{actual_count}"
      end
    end

    unless grouped.blank?
      grouped.each do |(type, flank, hp_percentage), count|
        @errors << "Expected not to have any #{type} in flank #{flank
          } with #{hp_percentage * 100}% HP @ #{location_str
          } but it did have #{count}."
      end
    end
  end

  match do |solar_system|
    @errors = []

    configuration.each do |position_str, data|
      position, angle = position_str.split(",").map(&:to_i)
      ss_conditions = {
        :position => position, :angle => angle,
        :solar_system_id => solar_system.id
      }

      case data["type"]
        when "planet"
          check_planet(position_str, ss_conditions, data)
        when "asteroid"
          check_asteroid(position_str, ss_conditions)
        when "jumpgate"
          check_jumpgate(position_str, ss_conditions)
      end

      location = SolarSystemPoint.new(solar_system.id, position, angle)

      check_wreckage(data['wreckage'], location) \
        unless data["wreckage"].nil?
      check_units(data['units'], location) unless data["units"].nil?
    end
    
    @errors.blank?
  end

  failure_message_for_should do |solar_system|
    "#{solar_system} should have had no errors but it did:\n\n" +
      @errors.map { |e| " * #{e}" }.join("\n")
  end

  failure_message_for_should_not do |solar_system|
    "#{solar_system} should have had some errors but it did not."
  end
end