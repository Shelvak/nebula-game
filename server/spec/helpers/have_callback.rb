Spec::Matchers.define :have_callback do |type, time|
  match do |object|
    CallbackManager.has?(object, type, 
      (time - SPEC_TIME_PRECISION)..(time + SPEC_TIME_PRECISION))
  end

  def r(type)
    CallbackManager::STRING_NAMES[type]
  end

  failure_message_for_should do |object|
    "#{object} should have callback '#{r(type)}' @ #{time} +/- #{
      SPEC_TIME_PRECISION}s but it does not."
  end

  failure_message_for_should_not do |object|
    "#{object} should not have callback '#{r(type)}' @ #{time} +/- #{
      SPEC_TIME_PRECISION}s but it does."
  end
end