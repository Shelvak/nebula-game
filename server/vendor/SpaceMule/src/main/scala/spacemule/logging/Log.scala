package spacemule.logging

import org.jruby.runtime.builtin.IRubyObject

/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 5/6/12
 * Time: 4:32 PM
 * To change this template use File | Settings | File Templates.
 */

object Log {
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

  private[this] val defaultComponent = "SpaceMule"

  def isWritten(level: Int) = logger.isWritten(level)

  def fatal(message: => String, component: => String=defaultComponent) {
    if (isWritten(Fatal.id)) logger.fatal(message, component)
  }
  def error(message: => String, component: => String=defaultComponent) {
    if (isWritten(Error.id)) logger.error(message, component)
  }
  def warn(message: => String, component: => String=defaultComponent) {
    if (isWritten(Warn.id)) logger.warn(message, component)
  }
  def info(message: => String, component: => String=defaultComponent) {
    if (isWritten(Info.id)) logger.info(message, component)
  }
  def debug(message: => String, component: => String=defaultComponent) {
    if (isWritten(Debug.id)) logger.debug(message, component)
  }

  def block[T](
    message: => String,
    level: Logger.Level.Value=Logger.Level.Info,
    component: => String=defaultComponent
  )(block: () => T): T = {
    if (isWritten(level.id)) {
      // Nasty work-around for jruby+scala magic clash.
      // If scala inner class is passed into jruby, funky exceptions like this:
      // Exception: java.lang.IncompatibleClassChangeError:
      // spacemule.modules.combat.Combat and spacemule.modules.combat.Combat
      // $$anonfun$spacemule$modules$combat$Combat$$simulateTick$1$$anonfun
      // $apply$mcV$sp$1$$anonfun$13 disagree on InnerClasses attribute
      // (NativeException) occur. BLAH.
      var retValue: Option[T] = None
      logger.logBlock(
        message, level.id, component,
        () => { retValue = Some(block()) }
      )
      retValue.get
    }
    else {
      block()
    }
  }
}
