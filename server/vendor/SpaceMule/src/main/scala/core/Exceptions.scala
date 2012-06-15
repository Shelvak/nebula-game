package core

/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 5/16/12
 * Time: 5:39 PM
 * To change this template use File | Settings | File Templates.
 */

object Exceptions {
  /**
   * Extends given exception, prepending error string to its message. Keeps
   * original class and stacktrace.
   *
   * @param error
   * @param exception
   */
  def extend[T <: Exception](error: String, exception: T): T = {
    val newException = exception.getClass.
      getDeclaredConstructor(classOf[String]).
      newInstance(error + ": " + exception.getMessage)
    newException.setStackTrace(exception.getStackTrace)
    newException
  }
}
