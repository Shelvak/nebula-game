RSpec::Matchers.define :need_technology do |technology, options|
  options ||= {:level => 1}

  match do |klass|
    klass.needed_technologies[technology] == options
  end

  failure_message_for_should do |klass|
    "#{klass} should need #{technology.to_s} (#{options.inspect
      }) but it did not!"
  end

  failure_message_for_should_not do |klass|
    "#{klass} should not need #{technology.to_s} (#{options.inspect
      }) but it did!"
  end
end