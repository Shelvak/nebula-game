Spec::Matchers.define :be_saved do
  match do |actual|
    @memory_attributes = actual.attributes
    @db_attributes = actual.class.find(actual.id).attributes
    @memory_attributes == @db_attributes
  end
  failure_message_for_should do |actual|
    msg = "#{actual} should been saved but it did not. " +
      "Attributes changed:\n\n"

    @db_attributes.each do |key, value|
      unless value == @memory_attributes[key]
        msg += "Key      : #{key.inspect}\n"
        msg += "In DB    : #{value.inspect}\n"
        msg += "In memory: #{@memory_attributes[key].inspect}\n"
        msg += "\n"
      end
    end

    msg
  end
  failure_message_for_should_not do |actual|
    "#{actual} should not have been saved but it was."
  end
end