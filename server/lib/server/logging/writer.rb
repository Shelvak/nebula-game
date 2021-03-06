# Ensures synchronized, ordered writing to log outputs.
class Logging::Writer
  include Singleton
  include MonitorMixin

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

  LEVEL_FATAL = 0
  LEVEL_ERROR = 1
  LEVEL_WARN = 2
  LEVEL_INFO = 3
  LEVEL_DEBUG = 4

  TYPE_TO_LEVEL = {
    :fatal => LEVEL_FATAL,
    :error => LEVEL_ERROR,
    :warn => LEVEL_WARN,
    :info => LEVEL_INFO,
    :debug => LEVEL_DEBUG
  }
  LEVEL_TO_TYPE = TYPE_TO_LEVEL.flip

  attr_reader :level
  def level=(value)
    synchronize { @level = value }
  end

  def config
    synchronize { @config }
  end

  def config=(config)
    synchronize do
      @config = config
      @level = TYPE_TO_LEVEL[config.level]
      @outputs = config.outputs
      @callbacks = config.callbacks

      config.outputs.each do |output|
        raise "#{output} must respond to #write and #flush !" \
          unless output.respond_to?(:write) && output.respond_to?(:flush)
      end
    end
  end

  # Reopens all log outputs.
  def reopen!
    synchronize do
      @outputs.each do |output|
        case output
        when File
          output.flush
          output.reopen(output.path)
        end
      end
    end
  end

  def write(type, message)
    synchronize do
      write_raw(message) if write?(type)
      # Issue callback after writing to log to ensure it is written first.
      callback(type, message)
    end
  end

  # Invoke callback based on type.
  def callback(type, message)
    synchronize do
      @callbacks[type].call(message) if @callbacks[type]
    end
  end

  # Should we write this level type to log?
  #
  # This is used by logger.
  def write?(type_or_level)
    level = type_or_level.is_a?(Fixnum) \
      ? type_or_level : TYPE_TO_LEVEL[type_or_level]
    synchronize { @level >= level }
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