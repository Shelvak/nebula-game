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
    rescue Exception => exception
    end

    @indent = old_indent
    end_name = message[0..10]
    end_name += "..." unless end_name == message

    # This one is used by scala to implement returns from closures.
    # So we catch it, save it, pretend that we have no exception, then raise
    # it at the end of the logger.
    if exception && exception.is_a?(NativeException) && exception.cause.is_a?(
      Java::scala.runtime.NonLocalReturnControl
    )
      non_local_jump = exception.cause
      exception = nil
    end

    if exception
      @block_buffer +=
        "[END of #{end_name} with EXCEPTION] #{timing} #{exception.inspect}\n"
      if exception.is_a?(NativeException)
        message = exception.message.include?("JVM backtrace:") \
          ? exception.message \
          : %Q{#{exception.message}

JVM backtrace:
#{exception.cause.backtrace.join("\n")}}
        raise exception.class, message
      else
        raise exception
      end
    else
      if @block_buffer.ends_with?(data)
        @block_buffer.chomp!
        @block_buffer += " #{timing}\n"
      else
        @block_buffer += " " * @indent
        @block_buffer += "[END of #{end_name}] #{timing}\n"
      end
    end

    # Ensure Scala non local jumps are preserved.
    raise non_local_jump if non_local_jump

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
    "%s[%s|%s|%s|%-5s] %s\n" % [
      ' ' * @indent,
      Time.now.strftime(DATETIME_FORMAT),
      self.class.thread_name, component, type, message
    ]
  end

  def write(type, data); writer.write(type, data); end
  def callback(type, data); writer.callback(type, data); end
  def writer; Logging::Writer.instance; end

  class << self
    def thread_name
      Celluloid.actor? ? Celluloid::Actor.name : "main"
    end
  end
end
