class Logging::Logger
  DATETIME_FORMAT = "%Y-%m-%d %H:%M:%S.%L"
  DEFAULT_COMPONENT = 'main'

  BLOCK_INDENT = 2

  def initialize
    @indent = 0
    # Buffer for block logging.
    @block_buffer = nil
    # Which log levels we are currently suppressing?
    @except_types = []
  end

  # Define logging methods
  Logging::Writer::TYPE_TO_LEVEL.each do |type, level|
    define_method(:"#{type}?") do
      ! @except_types.include?(type) && writer.write?(type)
    end
    define_method(type) do |message, component=DEFAULT_COMPONENT|
      data = data_for(component, type, message)
      if @block_buffer.nil?
        # We're not generating a block. Write out immediately.
        write(type, data)
      else
        if send(:"#{type}?")
          # Append to block buffer.
          @block_buffer += data
          # Invoke type callback.
          callback(type, data)
        end
      end
    end
  end

  def block(message, options={})
    options.reverse_merge!(:component => DEFAULT_COMPONENT, :level => :info)
    return yield unless send("#{options[:level]}?")

    data = data_for(options[:component], options[:level], message)
    if @block_buffer.nil?
      @block_buffer = data
      started_buffering = true
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
      timing = "[%5.3f seconds]" % (Time.now - start)
    rescue Exception => exception; end

    @indent = old_indent

    if @block_buffer.ends_with?(data)
      @block_buffer.chomp!
      @block_buffer += " #{timing}\n"
    else
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
    end

    returned
  ensure
    if started_buffering
      # Write buffer out.
      write(options[:level], @block_buffer + "\n")
      # Clear block buffer if this was the call that started buffering.
      @block_buffer = nil
    end
  end

  # Suppress given types for the duration of the block. Thread local.
  def except(*types)
    @except_types += types
    result = yield
    types.size.times { @except_types.pop }

    result
  end

  private
  def data_for(component, type, message)
    name = Celluloid.actor? ? Celluloid::Actor.name : "main"
    "%s[%s|%s|%s|%-5s] %s\n" % [
      ' ' * @indent,
      Time.now.strftime(DATETIME_FORMAT),
      name, component, type, message
    ]
  end

  def write(type, data); writer.write(type, data); end
  def callback(type, data); writer.callback(type, data); end
  def writer; Logging::Writer.instance; end
end
