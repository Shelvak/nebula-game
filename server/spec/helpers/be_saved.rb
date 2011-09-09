RSpec::Matchers.define :be_saved do
  match do |actual|
    @memory_attributes = actual.attributes
    @db_attributes = actual.class.find(actual.id).attributes
    
    matches = true
    @db_attributes.each do |key, value|
      matches = false unless equals(value, @memory_attributes[key])
    end
    matches
  end
  failure_message_for_should do |actual|
    msg = "#{actual} should been saved but it did not. " +
      "Attributes changed:\n\n"

    @db_attributes.each do |key, value|
      unless equals(value, @memory_attributes[key])
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

  def equals(val1, val2)
    if val1.is_a?(Time) && val2.is_a?(Time)
      (val1 - val2).abs.should <= SPEC_TIME_PRECISION
    elsif val1.is_a?(Float) && val2.is_a?(Float)
      (val1 - val2).abs.should <= SPEC_FLOAT_PRECISION
    else
      val1 == val2
    end
  end
end