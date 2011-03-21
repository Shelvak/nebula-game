package spacemule.helpers

object StdErrLog {
  private val IndentPerBlock = 2

  val Debug = 0
  val Info = 1
  val Warn = 2

  val DebugStr = "D"
  val InfoStr = "I"
  val WarnStr = "W"

  var level = Info

  def withLevel[T](level: Int)(block: () => T): T = {
    val oldLevel = this.level
    this.level = level
    val value = block()
    this.level = oldLevel
    value
  }

  def debug(s: => String) = if (level >= Debug) out(DebugStr, s)
  def debug[T](s: => String, code: () => T): T = block(Debug, DebugStr, s, code)

  def info(s: => String) = if (level >= Info) out(InfoStr, s)
  def info[T](s: => String, code: () => T): T = block(Info, InfoStr, s, code)

  def warn(s: => String) = if (level >= Warn) out(WarnStr, s)
  def warn[T](s: => String, code: () => T): T = block(Warn, WarnStr, s, code)

  private var indent = 0

  private def block[T](level: Int, levelStr: String, s: => String,
    code: () => T): T =
  {
    val print = this.level >= level
    if (print) {
      val msg = s
      out(levelStr, "[%s]".format(msg))

      val oldIndent = indent
      indent += IndentPerBlock

      val start = System.currentTimeMillis
      val value = code()
      val time = System.currentTimeMillis - start

      indent = oldIndent

      out(levelStr, "[END of %s...: %dms]".format(
          msg.substring(0, 10),
          time))
      value
    }
    else {
      code()
    }
  }

  private def out(level: String, s: String): Unit =
    System.err.println(level + "| " + (" " * indent) + s)
}
