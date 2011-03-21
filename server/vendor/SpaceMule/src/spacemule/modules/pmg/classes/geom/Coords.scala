package spacemule.modules.pmg.classes.geom

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 2:12:31 PM
 * To change this template use File | Settings | File Templates.
 */

object Coords {
  def apply(x: Int, y: Int): Coords = {
    return new Coords(x, y)
  }
}

class Coords(initialX: Int, initialY: Int) extends WithCoords {
  x = initialX
  y = initialY

  override def toString = "<Coords %d,%d>".format(x, y)
}