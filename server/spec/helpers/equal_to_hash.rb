RSpec::Matchers.define :equal_to_hash do |target|
  match do |actual|
    @errors = {}
    
    actual.each do |key, actual_value|
      target_value = target[key]
      if actual_value.is_a?(Time) && target_value.is_a?(Time)
        @errors[key] = [target_value, actual_value] unless (
          (
            target_value - SPEC_TIME_PRECISION
          )..(
            target_value + SPEC_TIME_PRECISION
          )
        ).cover?(actual_value)
      elsif actual_value.is_a?(Float) && target_value.is_a?(Float)
        @errors[key] = [target_value, actual_value] unless (
          (
            target_value - SPEC_FLOAT_PRECISION
          )..(
            target_value + SPEC_FLOAT_PRECISION
          )
        ).cover?(actual_value)
      elsif target_value.is_a?(RSpec::Matchers::Matcher)
        @errors[key] = [target_value.failure_message_for_should, actual_value] \
          unless target_value.matches?(actual_value)
      else
        @errors[key] = [target_value, actual_value] \
          unless actual_value == target_value
      end
    end
    
    @errors.blank?
  end
  failure_message_for_should do |actual|
    msg = "target and actual hashes should have been equal but these " +
      "differences were found:\n\n"

    @errors.each do |key, (expected_value, actual_value)|
      msg += "Key             : #{key.inspect}\n"
      msg += "Should have been: #{expected_value.inspect}\n"
      msg += "But was         : #{actual_value.inspect}\n"
      msg += "\n"
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