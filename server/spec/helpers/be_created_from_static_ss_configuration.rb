RSpec::Matchers.define :be_created_from_static_ss_configuration do
  |configuration|

  def check_planet(position_str, ss_conditions, data)
    if SsObject::Planet.where(ss_conditions).exists?
      planet = SsObject::Planet.where(ss_conditions).first

      owned_by_player = ! planet.player_id.nil?
      @errors << "Expected planet @ #{position_str
        } to have owned_by_player: #{data["owned_by_player"]
        } but it was #{owned_by_player}." \
        if owned_by_player != data["owned_by_player"]

      @errors << "Expected planet @ #{position_str
        } to have next_raid_at but it did not." if planet.next_raid_at.nil?

      @errors << "Expected planet @ #{position_str
        } to have raid_arg set to 0, but it was set to #{planet.raid_arg}" \
        unless planet.raid_arg == 0

      @errors << "Expected planet @ #{position_str
        } to have raid callback registered but it did not." \
        unless CallbackManager.has?(
          planet, CallbackManager::EVENT_RAID, planet.next_raid_at
        )

      # TODO: check planet map configuration.
    else
      @errors << "Expected planet @ #{position_str} to exist but it did not."
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

  def check_units(units_data, location)
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
          flank} with #{hp_percentage * 100}% HP @ #{location
          }, but only had #{actual_count}"
      end
    end

    unless grouped.blank?
      grouped.each do |(type, flank, hp_percentage), count|
        @errors << "Expected not to have any #{type} in flank #{flank
          } with #{hp_percentage * 100}% HP @ #{location
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