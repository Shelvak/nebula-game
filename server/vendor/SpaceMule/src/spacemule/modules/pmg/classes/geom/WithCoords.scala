package spacemule.modules.pmg.classes.geom

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 1:41:18 PM
 * To change this template use File | Settings | File Templates.
 */

trait WithCoords {
  var x = 0
  var y = 0

  def position = x
  def position_=(value: Int) = { x = value }
  def angle = y
  def angle_=(value: Int) = { y = value }

  override def equals(other: Any): Boolean = {
    return other match {
      case other: WithCoords => x == other.x && y == other.y
      case _ => false
    }
  }

  override def hashCode(): Int = {
    return x * 7 + y * 7
  }

  override def toString(): String = {
    "<WithCoords @ %d,%d>".format(x, y)
  }
}