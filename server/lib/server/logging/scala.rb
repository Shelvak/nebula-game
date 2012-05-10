class Logging::Scala
  include Java::spacemule.logging.Logger

  def initialize(logger)
    @logger = logger
  end

  #def isWritten(level: Int): Boolean
  def isWritten(level)
    Logging::Writer.instance.write?(level)
  end

  #def fatal(message: String, component: String): Unit
  #def error(message: String, component: String): Unit
  #def warn(message: String, component: String): Unit
  #def info(message: String, component: String): Unit
  #def debug(message: String, component: String): Unit
  Logging::Writer::TYPE_TO_LEVEL.keys.each do |type|
    define_method(type) do |message, component|
      @logger.send(type, message, component)
    end
  end

  #def logBlock[T](
  #  message: String, level: Int, component: String, block: () => T
  #): T
  def logBlock(message, level, component, block)
    ret_val = @logger.block(
      message, level: Logging::Writer::LEVEL_TO_TYPE[level],
      component: component
    ) { block.apply }

    # Avoid unnecessary conversion to Long when we really expect Int.
    return ret_val.to_java(:int) if ret_val.is_a?(Fixnum) &&
      ret_val > Java::scala.Int.MinValue && ret_val < Java::scala.Int.MaxValue
    ret_val
  end
end