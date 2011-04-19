class GameLogger
  DATETIME_FORMAT = "%Y-%m-%d %H:%M:%S"
  DEFAULT_SERVER_NAME = 'main'

  LEVEL_FATAL = 0
  LEVEL_ERROR = 1
  LEVEL_WARN = 2
  LEVEL_INFO = 3
  LEVEL_TRAFFIC_DEBUG = 4
  LEVEL_DEBUG = 5

  TYPE_TO_LEVEL = {
    :fatal => LEVEL_FATAL,
    :error => LEVEL_ERROR,
    :warn => LEVEL_WARN,
    :info => LEVEL_INFO,
    :traffic_debug => LEVEL_TRAFFIC_DEBUG,
    :debug => LEVEL_DEBUG
  }

  BLOCK_INDENT = 4

  attr_accessor :level, :outputs

  def initialize(*outputs)
    @outputs = outputs.compact.map do |output|
      case output
      when String
        File.new(output, 'a')
      else
        output
      end
    end
    @include_time = true
    @indent = 0
    @level = LEVEL_WARN
    @callbacks = {}
  end

  # Reopens all log outputs.
  def reopen!
    @outputs.each do |output|
      case output
      when File
        output.reopen(output.path)
      end
    end
  end

  def request(message, server_name=nil, client_addr=nil, &block)
    block("REQUEST from #{client_addr}", message, server_name, &block)
  end

  def block(block_message, message_or_options=nil, server_name=nil)
    options = message_or_options.is_a?(Hash) ? message_or_options :
      {:message => message_or_options, :server_name => server_name}
    message_level = options[:level] || :info
    should_write = write?(message_level)
    returned = nil

    if should_write
      write_raw "\n"
      send(message_level, "[#{block_message}]", options[:server_name])
      old_indent = @indent
      @indent += BLOCK_INDENT
      @include_time = false

      send(message_level, options[:message], options[:server_name]) \
        if options[:message]

      # Ensure exceptions don't ruin our formatting
      exception = nil
      begin
        start = Time.now
        returned = yield
        message = "%5.3f seconds" % (Time.now - start)
      rescue Exception => exception; end

      @indent = old_indent
      @include_time = true

      write_raw " " * @indent
      end_name = block_message[0..10]
      end_name += "..." unless end_name == block_message

      if exception
        write_raw "[END of #{end_name} with EXCEPTION] #{
          exception.inspect}\n"
        raise exception
      else
        write_raw "[END of #{end_name}] #{message}\n\n"
      end
    else
      # Just yield the block
      returned = yield
    end

    returned
  end

  TYPE_TO_LEVEL.each do |type, level|
    define_method("#{type}?") { @level >= level }
    define_method(type) do |message, server_name=DEFAULT_SERVER_NAME|
      write(server_name, type, message)
      @callbacks[type].call(message) if @callbacks[type]
    end
    define_method("on_#{type}=") do |callback|
      @callbacks[type] = callback
    end
  end

  def suppress(type)
    old_level = @level
    @level = TYPE_TO_LEVEL[type] - 1
    result = yield
    @level = old_level

    result
  end

  # Should we write this level type to log?
  def write?(type)
    @level >= TYPE_TO_LEVEL[type]
  end

  def write(server_name, type, message)
    if write?(type)
      write_raw("%s[%s%s|%-5s] %s\n" % [
        ' ' * @indent,
        @include_time ? "#{Time.now.strftime(DATETIME_FORMAT)}|" : "",
        server_name,
        type,        
        message
      ])
    end
  end

  def write_raw(message)
    @outputs.each do |output|
      output.write(message)
      begin
        output.flush
      rescue IOError
        # Not ready for flush
      end
    end
  end
end
