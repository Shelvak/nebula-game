package core

/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 5/16/12
 * Time: 5:45 PM
 * To change this template use File | Settings | File Templates.
 */

object Values {
  implicit def any2double(value: Any) = value match {
    case i: Int => i.toDouble
    case l: Long => l.toDouble
    case f: Float => f.toDouble
    case d: Double => d
    case _ =>
      throw new IllegalArgumentException("Cannot cast "+value+" to double!")
  }

  implicit def long2int(long: Long) = long.toInt
}
