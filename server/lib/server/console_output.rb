class ConsoleOutput < IO
  CUTOFF_AT = 1000

  def initialize(output)
    @output = output
  end

  def write(string)
    length = string.length
    if length > CUTOFF_AT
      string = string[0..CUTOFF_AT] +
        "... (#{length - CUTOFF_AT} more characters)" + "\n"
    end

    @output.write string
  end
end
