RSpec::Matchers.define :cover do |value|
  match do |range|
    range.cover?(value)
  end

  failure_message_for_should do |range|
    "Range #{range.inspect} should cover #{value.inspect} but it does not!"
  end

  failure_message_for_should_not do |range|
    "Range #{range.inspect} should not cover #{value.inspect} but it does!"
  end
end