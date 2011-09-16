RSpec::Matchers.define :manage_resources do
  match do |klass|
    klass.manages_resources?
  end

  failure_message_for_should do |klass|
    "#{klass} should manage resources but it did not"
  end

  failure_message_for_should_not do |klass|
    "#{klass} should not manage resources but it did"
  end
end