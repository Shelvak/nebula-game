RSpec::Matchers.define :be_created_from_static_ss_configuration do |config_key|
  match do |solar_system|
    @errors = []

    CONFIG[config_key].each do |position_str, data|
      position, angle = position_str.split(",").map(&:to_i)
      ss_conditions = {
        :position => position, :angle => angle,
        :solar_system_id => solar_system.id
      }

      case data["type"]
        when "planet"
          owned_by_player = ! SsObject::Planet.where(ss_conditions).
            select("player_id").c_select_value.nil?
          if owned_by_player != data["owned_by_player"]
            @errors << "Expected planet @ #{position_str
              } to have owned_by_player: #{data["owned_by_player"]
              } but it was #{owned_by_player}."
          end
        when "asteroid"
          row = SsObject::Asteroid.where(ss_conditions).
            select(
              Resources::TYPES.map { |t| "#{t}_generation_rate" }.join(", ")
            ).
            c_select_one

          if row.nil?
            @errors << "Expected asteroid to exist @ #{position_str
              } but it did not."
          else
            Resources::TYPES.each_with_index do |type, index|
              actual = row["#{type}_generation_rate"]
              expected = data["resources"][index]
              if actual != expected
                @errors << "Expected asteroid @ #{position_str
                  } to have #{type} rate of #{expected} but it had rate of #{
                  actual}."
              end
            end
          end
        when "jumpgate"
          row = SsObject::Jumpgate.where(ss_conditions).select("id").
            c_select_value

          if row.nil?
            @errors << "Expected jumpgate to exist @ #{position_str
              } but it did not."
          end
      end

      if data["wreckage"]
        row = Wreckage.
          in_location(SolarSystemPoint.new(solar_system.id, position, angle)).
          select(Resources::TYPES.join(", ")).
          c_select_one

        if row.nil?
          @errors << "Expected wreckage to exist @ #{position_str
            } but it did not."
        else
          Resources::TYPES.each_with_index do |type, index|
            actual = row[type.to_s]
            expected = data["wreckage"][index]
            if actual != expected
              @errors << "Expected wreckage @ #{position_str
                } to have #{type} amount of #{expected} but it had #{actual}."
            end
          end
        end
      end

      unless data["units"].nil?
        location = SolarSystemPoint.new(solar_system.id, position, angle)
        grouped = Unit.in_location(location).all.grouped_counts do |unit|
          # Can't use Unit#type because it RANDOMLY returns Unit#class instead
          # of actual #type attribute... Fuck that.
          [unit[:type], unit.flank, unit.hp_percentage]
        end

        #"units" => [[1, "dirac", 0, 1.0]]
        data["units"].each do |expected_count, type, flank, hp_percentage|
          key = [type, flank, hp_percentage.to_f]
          actual_count = grouped.delete(key) || 0
          unless actual_count == expected_count
            @errors << "Expected to have #{expected_count} #{type} in flank #{
              flank} with #{hp_percentage * 100}% HP @ #{position_str
              }, but only had #{actual_count}"
          end
        end

        unless grouped.blank?
          grouped.each do |(type, flank, hp_percentage), count|
            @errors << "Expected not to have any #{type} in flank #{flank
              } with #{hp_percentage * 100}% HP @ #{position_str
              } but it did have #{count}."
          end
        end
      end
    end
    
    @errors.blank?
  end

  failure_message_for_should do |location|
    "#{location} should have had no errors but it did:\n\n" +
      @errors.map { |e| " * #{e}" }.join("\n")
  end

  failure_message_for_should_not do |location|
    "#{location} should have had some errors but it did not."
  end
end