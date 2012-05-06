package spacemule.logging

import java.util.concurrent.locks.ReentrantLock

/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 5/6/12
 * Time: 4:31 PM
 * To change this template use File | Settings | File Templates.
 */

object Logger {
  object Level extends Enumeration {
    val Fatal = Value(0, "fatal")
    val Error = Value(1, "error")
    val Warn = Value(2, "warn")
    val Info = Value(3, "info")
    val TrafficDebug = Value(4, "traffic_debug")
    val Debug = Value(5, "debug")
  }
}

// Implemented from Ruby.
trait Logger {
  def defaultComponent: String

  def isWritten(level: Int): Boolean

  def fatal(message: String, component: String): Unit
  def error(message: String, component: String): Unit
  def warn(message: String, component: String): Unit
  def info(message: String, component: String): Unit
  def debug(message: String, component: String): Unit

  def logBlock[T](
    message: String, level: Int, component: String, block: () => T
  ): T
}
