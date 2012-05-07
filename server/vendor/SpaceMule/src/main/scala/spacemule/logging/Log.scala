package spacemule.logging

/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 5/6/12
 * Time: 4:32 PM
 * To change this template use File | Settings | File Templates.
 */

object Log extends Logger {
  private[this] var _logger: Logger = null;

  private[this] def logger =
    if (_logger != null) _logger
    else throw new IllegalStateException("Logger is not set yet.")
  def setLogger(logger: Logger) { _logger = logger }

  val Fatal = Logger.Level.Fatal
  val Error = Logger.Level.Error
  val Warn = Logger.Level.Warn
  val Info = Logger.Level.Info
  val Debug = Logger.Level.Debug

  def defaultComponent = logger.defaultComponent
  def isWritten(level: Int) = logger.isWritten(level)
  def fatal(message: String, component: String=defaultComponent) {
    logger.fatal(message, component)
  }
  def error(message: String, component: String=defaultComponent) {
    logger.error(message, component)
  }
  def warn(message: String, component: String=defaultComponent) {
    logger.warn(message, component)
  }
  def info(message: String, component: String=defaultComponent) {
    logger.info(message, component)
  }
  def debug(message: String, component: String=defaultComponent) {
    logger.debug(message, component)
  }
  def logBlock[T](
    message: String, level: Int, component: String, block: () => T
  ) = logger.logBlock(message, level, component, block)

  def block[T](
    message: => String,
    level: Logger.Level.Value=Logger.Level.Info,
    component: String=defaultComponent
  )(block: () => T) = {
    if (isWritten(level.id)) {
      logBlock(message, level.id, component, block)
    }
    else {
      block()
    }
  }
}
