Spec::Matchers.define :equal_to_hash do |target|
  match do |actual|
    equal = true
    
    actual.each do |key, actual_value|
      target_value = target[key]
      if actual_value.is_a?(Time) && target_value.is_a?(Time)
        equal = false unless (
          (
            target_value - SPEC_TIME_PRECISION
          )..(
            target_value + SPEC_TIME_PRECISION
          )
        ).cover?(actual_value)
      elsif actual_value.is_a?(Float) && target_value.is_a?(Float)
        (
          (
            target_value - SPEC_FLOAT_PRECISION
          )..(
            target_value + SPEC_FLOAT_PRECISION
          )
        ).cover?(actual_value)
      else
        equal = false unless actual_value == target_value
      end
    end
    
    equal
  end
  failure_message_for_should do |actual|
    msg = "target and actual hashes should have been equal but these " +
      "differences were found:\n\n"

    target.each do |key, value|
      unless target[key] == actual[key]
        msg += "Key             : #{key.inspect}\n"
        msg += "Should have been: #{target[key].inspect}\n"
        msg += "But was         : #{actual[key].inspect}\n"
        msg += "\n"
      end
    end

    msg
  end
  failure_message_for_should_not do |actual|
    "target and actual hashes should have not been equal but they were"
  end
  description do
    "Matches two hashes and displays differences if they are not equal."
  end
end