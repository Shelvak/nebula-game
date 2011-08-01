Spec::Matchers.define :have_correct_unit_count do |*config_keys|
  match do |location|
    @location = location
    @errors = {}
    grouped = Unit.in_location(location).group_by do |unit|
      raise "#{unit.inspect} is not a Unit!" unless unit.is_a?(Unit)
      [unit.type, unit.flank]
    end
    
    success = false
    config_keys.each do |config_key|
      value_success = true
      
      values = CONFIG[config_key]
      raise ArgumentError.new("Unknown config key #{config_key}!") \
        if values.nil?
      
      if values.blank?
        value_success = grouped.size == 0
      else
        values.each do |type, count_range, flanks|
          type = type.camelcase
          count_range = count_range.is_a?(Fixnum) \
            ? (count_range..count_range) \
            : (count_range[0]..count_range[1])
          flanks = [flanks] if flanks.is_a?(Fixnum)

          count = 0
          flanks.each do |flank|
            count += (grouped[[type, flank]] || []).size
          end

          unless count_range.include?(count)
            value_success = false
            @errors[config_key] ||= []
            @errors[config_key].push "Expected #{type} to be in #{
              count_range} in flanks #{flanks.inspect} but it was #{count}."
          end
        end
      end
      
      success = true if value_success
    end
    
    success
  end

  failure_message_for_should do |location|
    "#{location} should have had correct unit count but it did not. " +
      "Errors were:\n\n" +
      @errors.map do |config_name, errors|
        "  For config value '#{config_name}':\n" +
          errors.map { |error| "    * #{error}" }.join("\n")
      end.join("\n\n")
  end

  failure_message_for_should_not do |location|
    "#{location} should not have had correct unit count but it did."
  end
end