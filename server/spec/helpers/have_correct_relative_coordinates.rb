RSpec::Matchers.define :have_correct_relative_coordinates do |config_key|
  match do |solar_systems|
    actual = solar_systems.each_with_object({}) do |solar_system, hash|
      coords = Galaxy::Zone.relative_coords(solar_system.x, solar_system.y)
      hash[coords] = solar_system
    end

    @errors = []

    (actual.keys - CONFIG[config_key]).each do |coords|
      ss = actual[coords]
      @errors << "Expected #{ss.x},#{ss.y} (rel: #{coords[0]},#{coords[1]
        }) not to exist but it did with #{ss}."
    end

    (CONFIG[config_key] - actual.keys).each do |coords|
      @errors << "Expected #{coords[0]},#{coords[1]} to exist but it did not."
    end

    @errors.blank?
  end

  failure_message_for_should do |_|
    errors = @errors.map { |e| " * #{e}" }.join("\n")
    "Solar systems should have correct relative coordinates:\n#{errors}"
  end

  failure_message_for_should_not do |_|
    "Solar systems should not have correct relative coordinates but they had."
  end
end