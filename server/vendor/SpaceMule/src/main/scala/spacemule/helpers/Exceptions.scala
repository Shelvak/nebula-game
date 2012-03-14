package spacemule.helpers

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 3/14/12
 * Time: 5:29 PM
 * To change this template use File | Settings | File Templates.
 */

object Exceptions {
  type ExceptionBuilder = (String, Exception) => Exception

  implicit def defaultException = (message: String, cause: Exception) => {
    new RuntimeException(message, cause)
  }

  def wrappingException[T](msg: String)(function: () => T)(
    implicit exceptionBuilder: ExceptionBuilder
  ): T = {
    try {
      function()
    }
    catch {
      case e: Exception =>
        throw exceptionBuilder(
          "%s\n%s: %s".format(msg, e.getClass.toString, e.getMessage),
          e
        )
    }
  }
}
