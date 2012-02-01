class StreamBuffer
  def initialize(separator="\n")
    @separator = separator
    @buffer = ""
  end

  def data(data)
    @buffer += data
  end

  def each_message
    newline_at = @buffer.index(@separator)
    until newline_at.nil?
      # Get our message.
      message = @buffer[0...newline_at]
      # Leave other part of buffer for further processing.
      @buffer = @buffer[(newline_at + 1)..-1]

      yield message

      newline_at = @buffer.index(@separator)
    end
  end
end