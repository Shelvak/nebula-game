RSpec::Matchers.define :have_generation_rates do |*config_keys|
  expected_values = config_keys.map do |key|
    [
      key,
      Resources::TYPES.map do |resource|
        from, to = CONFIG["#{key}.#{resource}_rate"]
        from..to
      end
    ]
  end

  match do |asteroid|
    @rates = Resources::TYPES.map do |resource|
      asteroid.send("#{resource}_generation_rate")
    end

    matched = false
    expected_values.each do |_, ranges|
      key_matched = true

      ranges.each_with_index do |range, index|
        key_matched = false unless range.cover?(@rates[index])
      end

      matched = matched || key_matched
    end

    matched
  end

  def resource_ranges_str(expected)
    expected_str = ""

    expected.each do |key, ranges|
      expected_str += "  #{key}:\n"
      Resources::TYPES.each_with_index do |resource, index|
        expected_str += "    #{resource}: #{ranges[index]}\n"
      end
    end

    expected_str
  end

  def rates_str(rates)
    expected_str = ""

    Resources::TYPES.each_with_index do |resource, index|
      expected_str += "  #{resource}: #{rates[index]}\n"
    end

    expected_str
  end

  failure_message_for_should do |asteroid|
    %Q{#{asteroid} should have had its resources in one of these ranges:
#{resource_ranges_str(expected_values)}
but it actually was:
#{rates_str(@rates)}}
  end

  failure_message_for_should_not do |asteroid|
    %Q{#{asteroid} should not have had its resources in any of these ranges:
#{resource_ranges_str(expected_values)}
but it actually did with:
#{rates_str(@rates)}}
  end
end