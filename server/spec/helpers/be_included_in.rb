Spec::Matchers.define :be_included_in do |target|
  match do |given|
    target.include?(given)
  end

  failure_message_for_should do |given|
    "#{given} should be included in #{target} but it was not"
  end

  failure_message_for_should_not do |given|
    "#{given} should not be included in #{target} but it was"
  end
end