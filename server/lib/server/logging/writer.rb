# Ensures synchronized, ordered writing to logfiles.
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

    config.outputs.each do |output|
      raise "#{output} must respond to #write and #flush !" \
            unless output.respond_to?(:write) && output.respond_to?(:flush)
    end

    Thread.current[:name] = "log_writer"
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
    write_raw(message) if write?(type)
  end

  # Should we write this level type to log?
  def write?(type)
    @level >= TYPE_TO_LEVEL[type]
  end

  private

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