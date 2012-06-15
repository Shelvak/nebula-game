package core

object AnyConversions {
  implicit def extendAny(obj: Any) = new AnyExtensions(obj)
}

class AnyExtensions(obj: Any) {
  def asDouble = obj match {
    case i: Int => i.toDouble
    case l: Long => l.toDouble
    case f: Float => f.toDouble
    case d: Double => d
    case _ =>
      throw new NumberFormatException("Cannot convert " + obj + " to Double.")
  }

  def asInt = obj match {
    case i: Int => i
    case l: Long => l.toInt
    case f: Float if (f % 1 == 0) => f.toInt
    case d: Double if (d % 1 == 0) => d.toInt
    case _ =>
      throw new NumberFormatException("Cannot convert " + obj + " to Int.")
  }
}
