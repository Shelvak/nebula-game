RSpec::Matchers.define :have_callback do |type, time|
  match do |object|
    match_time = time.is_a?(Time) \
      ? (time - SPEC_TIME_PRECISION)..(time + SPEC_TIME_PRECISION) \
      : time

    CallbackManager.has?(object, type, match_time)
  end

  def r(type)
    CallbackManager::METHOD_NAMES[type]
  end
  
  def time_str(time)
    case time
    when Time
      "#{time} +/- #{SPEC_TIME_PRECISION}s"
    when Range
      time.to_s
    when nil
      "any time"
    else
      time.inspect
    end
  end

  failure_message_for_should do |object|
    "#{object} should have callback '#{r(type)}' @ #{
      time_str(time)} but it does not."
  end

  failure_message_for_should_not do |object|
    "#{object} should not have callback '#{r(type)}' @ #{
      time_str(time)} but it does."
  end
end