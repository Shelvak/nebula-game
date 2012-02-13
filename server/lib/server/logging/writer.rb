# Ensures synchronized, ordered writing to log outputs.
class Logging::Writer
  class Config
    attr_accessor :level, :outputs, :callbacks

    def initialize(level)
      @level = level
      @outputs = []
      @callbacks = {}
    end

    def freeze
      @outputs.freeze
      @callbacks.freeze
      super()
    end
  end

  include Celluloid

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

  attr_accessor :level

  def initialize(config)
    @level = TYPE_TO_LEVEL[config.level]
    @outputs = config.outputs
    @callbacks = config.callbacks
    @suspend_counter = 0
    @suspend_buffer = []

    config.outputs.each do |output|
      raise "#{output} must respond to #write and #flush !" \
            unless output.respond_to?(:write) && output.respond_to?(:flush)
    end
  end

  # Reopens all log outputs.
  def reopen
    @outputs.each do |output|
      case output
      when File
        output.flush
        output.reopen(output.path)
      end
    end
  end

  def write(type, message)
    @callbacks[type].call(message) if @callbacks[type]
    if write?(type)
      if suspended?
        @suspend_buffer << [Time.now, message]
      else
        write_raw(message)
      end
    end
  end

  # Should we write this level type to log?
  def write?(type)
    @level >= TYPE_TO_LEVEL[type]
  end

  # Suspend message logging. While writer is suspended all messages will be
  # buffered. #suspend can be called several times, #resume must be called same
  # amount of times to resume writing.
  def suspend
    @suspend_counter += 1
    puts "Suspending, counter: #{@suspend_counter}"
  end

  # Resume message logging.
  def resume
    @suspend_counter -= 1
    puts "Resuming, counter: #{@suspend_counter}"
    if @suspend_counter == 0
      # Sort all messages we received while we were suspended and write them
      # out.
      @suspend_buffer.sort { |a, b| a[0] <=> b[0] }.each do |time, message|
        write_raw(message)
      end
      @suspend_buffer.clear
    elsif @suspend_counter < 0
      raise "Cannot resume, not suspended!"
    end
  end

  private
  def suspended?
    @suspend_counter != 0
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