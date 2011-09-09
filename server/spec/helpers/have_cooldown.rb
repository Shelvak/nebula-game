RSpec::Matchers.define :have_cooldown do |time|
  match do |object|
    cooldown = Cooldown.in_location(object).first
    if cooldown.nil?
      false
    else
      time = (time - SPEC_TIME_PRECISION)..(time + SPEC_TIME_PRECISION)
      time.cover?(cooldown.ends_at)
    end
  end

  failure_message_for_should do |object|
    "#{object} should have cooldown @ #{time} +/- #{
      SPEC_TIME_PRECISION}s but it does not."
  end

  failure_message_for_should_not do |object|
    "#{object} should not have cooldown @ #{time} +/- #{
      SPEC_TIME_PRECISION}s but it does."
  end
end