class HaveGaps
  def initialize(expected)
    @expected = expected
  end

  def matches?(target)
    @target = target
    @actual = target.size - target.compact.size

    @expected.include?(@actual)
  end

  def failure_message
    "expected planets to have #{@expected} gaps, but it had #{@actual}\n" +
    "Planets: #{@target.inspect}"
  end

  def negative_failure_message
    "expected planets not to have #{@expected} gaps, but it had #{@actual}\n" +
    "Planets: #{@target.inspect}"
  end
end

def have_gaps(key)
  HaveGaps.new(CONFIG["#{key}.from"]..CONFIG["#{key}.to"])
end