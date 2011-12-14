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
          terrain = SsObject::Planet.where(ss_conditions).select("terrain").
            c_select_value
          if terrain.nil?
            @errors << "Expected planet to exist @ #{position_str
              } but it did not."
          elsif terrain != data["terrain"]
            @errors << "Expected planet @ #{position_str
              } to have terrain type #{data["terrain"]
              } but it had terrain type #{terrain}."
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
    end


    #@location = location
    #grouped = Unit.in_location(location).all.grouped_counts do |unit|
    #  # Can't use Unit#type because it RANDOMLY returns Unit#class instead
    #  # of actual #type attribute... Fuck that.
    #  [unit[:type], unit.flank]
    #end
    #
    #config_keys.each do |config_key|
    #  values = CONFIG[config_key]
    #  raise ArgumentError.new("Unknown config key #{config_key}!") \
    #    if values.nil?
    #
    #  if values.blank?
    #    unless grouped.size == 0
    #      @errors[config_key] ||= []
    #      @errors[config_key].push "Expected no units, but had #{
    #        grouped.inspect}"
    #    end
    #  else
    #    values.each do |type, count_range, flanks|
    #      type = type.camelcase
    #      count_range = count_range.is_a?(Fixnum) \
    #        ? (count_range..count_range) \
    #        : (count_range[0]..count_range[1])
    #      flanks = [flanks] if flanks.is_a?(Fixnum)
    #
    #      count = flanks.map { |flank| grouped[[type, flank]] || 0 }.sum
    #
    #      unless count_range.include?(count)
    #        @errors[config_key] ||= []
    #        @errors[config_key].push "Expected #{type} to be in #{
    #          count_range} in flanks #{flanks.inspect} but it was #{count}."
    #      end
    #    end
    #  end
    #end
    
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