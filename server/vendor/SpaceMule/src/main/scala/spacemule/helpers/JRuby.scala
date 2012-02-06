package spacemule.helpers

/**
 * Helpers for JRuby interoperability.
 */
object JRuby {
  /**
   * This is needed, because from JRuby Java::scala.None is actually something
   * different than None obtained from Scala in such way.
   *
   * >> Java::scala.None
   * => Java::Scala::None
   * >> Java::spacemule.helpers.JRuby.None
   * => #<#<Class:0x10060d664>:0x69a54c>
   */
  val None = scala.None

  def rethrow(exception: Exception, message: String) {
    val e = exception.getClass.getDeclaredConstructor(classOf[String]).
      newInstance(message + "\n\n" + exception.getMessage).
      asInstanceOf[Exception]
    e.initCause(exception.getCause)
    e.setStackTrace(exception.getStackTrace)
    throw e
  }
}