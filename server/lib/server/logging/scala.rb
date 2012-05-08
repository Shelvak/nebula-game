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
    @logger.block(
      message, level: Logging::Writer::LEVEL_TO_TYPE[level],
      component: component
    ) { block.apply }
  end
end