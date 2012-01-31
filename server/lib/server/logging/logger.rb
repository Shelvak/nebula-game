class Logging::Logger
  DATETIME_FORMAT = "%Y-%m-%d %H:%M:%S"
  DEFAULT_COMPONENT = 'main'

  BLOCK_INDENT = 4

  def initialize
    @include_time = true
    @indent = 0
    # Buffer for block logging.
    @block_buffer = nil
    # Which log levels we are currently suppressing?
    @suppressing = []
  end

  # Define logging methods
  Logging::Writer::TYPE_TO_LEVEL.each do |type, level|
    define_method(:"#{type}?") do
      ! @suppressing.include?(type) &&
        Celluloid::Actor[:log_writer].write?(type)
    end
    define_method(type) do |message, component=DEFAULT_COMPONENT|
      data = data_for(component, type, message)
      if @block_buffer.nil?
        # We're not generating a block. Write out immediately.
        write(type, data)
      else
        # Append to block buffer.
        @block_buffer += data
      end
    end
  end

  def block(message, options={})
    options.reverse_merge!(:component => DEFAULT_COMPONENT, :level => :info)

    data = data_for(options[:component], options[:level], message)
    if @block_buffer.nil?
      @block_buffer = data
      started_buffering = true
      @include_time = false
    else
      @block_buffer += data
    end

    old_indent = @indent
    @indent += BLOCK_INDENT

    # Ensure exceptions don't ruin our formatting
    exception = nil
    returned = nil
    timing = nil
    begin
      start = Time.now
      returned = yield
      timing = "%5.3f seconds" % (Time.now - start)
    rescue Exception => exception; end

    @indent = old_indent

    @block_buffer += " " * @indent
    end_name = message[0..10]
    end_name += "..." unless end_name == message

    if exception
      @block_buffer +=
        "[END of #{end_name} with EXCEPTION] #{timing} #{exception.inspect}\n"
      raise exception
    else
      @block_buffer += "[END of #{end_name}] #{timing}\n"
    end

    returned
  ensure
    if started_buffering
      # Write buffer out.
      write(options[:level], @block_buffer + "\n")
      # Clear block buffer if this was the call that started buffering.
      @block_buffer = nil
      @include_time = true
    end
  end

  # Suppress given types for the duration of the block. Thread local.
  def suppress(*types)
    puts "Suppress called with #{types.inspect}"
    @suppressing += types
    result = yield
    types.size.times { @suppressing.pop }

    result
  end

  private
  def data_for(component, type, message)
    "%s[%s%s|%s|%-5s] %s\n" % [
      ' ' * @indent,
      @include_time ? "#{Time.now.strftime(DATETIME_FORMAT)}|" : "",
      Thread.current[:name] || "t_#{Thread.current.object_id}",
      component, type, message
    ]
  end

  def write(type, data)
    Celluloid::Actor[:log_writer].write!(type, data)
  end
end
