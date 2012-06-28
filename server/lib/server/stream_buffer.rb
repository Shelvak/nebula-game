class StreamBuffer
  # Maximum size of data stored in a buffer.
  MAX_SIZE = 50 * 1024

  # Raised when buffer size is greater than MAX_SIZE.
  class OverflowError < RuntimeError; end

  def initialize(separator="\n")
    @separator = separator
    @buffer = ""
  end

  def data(data)
    raise OverflowError if @buffer.size + data.size > MAX_SIZE
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