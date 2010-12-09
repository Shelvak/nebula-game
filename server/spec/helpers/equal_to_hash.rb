Spec::Matchers.define :equal_to_hash do |target|
  match do |actual|
    actual == target
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