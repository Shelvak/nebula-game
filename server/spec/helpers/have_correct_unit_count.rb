RSpec::Matchers.define :have_correct_unit_count do |*config_keys|
  match do |location|
    @location = location
    @errors = {}
    grouped = Unit.in_location(location).all.grouped_counts do |unit|
      # Can't use Unit#type because it RANDOMLY returns Unit#class instead
      # of actual #type attribute... Fuck that.
      [unit[:type], unit.flank]
    end
    
    config_keys.each do |config_key|
      values = CONFIG[config_key]
      raise ArgumentError.new("Unknown config key #{config_key}!") \
        if values.nil?
      
      if values.blank?
        unless grouped.size == 0
          @errors[config_key] ||= []
          @errors[config_key].push "Expected no units, but had #{
            grouped.inspect}"
        end
      else
        values.each do |type, count_range, flanks|
          type = type.camelcase
          count_range = count_range.is_a?(Fixnum) \
            ? (count_range..count_range) \
            : (count_range[0]..count_range[1])
          flanks = [flanks] if flanks.is_a?(Fixnum)

          count = flanks.map { |flank| grouped[[type, flank]] || 0 }.sum

          unless count_range.include?(count)
            @errors[config_key] ||= []
            @errors[config_key].push "Expected #{type} to be in #{
              count_range} in flanks #{flanks.inspect} but it was #{count}."
          end
        end
      end
    end
    
    # Success if at least one combination had no errors.
    @errors.keys.size < config_keys.size
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