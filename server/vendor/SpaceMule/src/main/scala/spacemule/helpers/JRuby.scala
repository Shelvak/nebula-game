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
}