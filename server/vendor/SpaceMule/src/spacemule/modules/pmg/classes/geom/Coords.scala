package spacemule.modules.pmg.classes.geom

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 2:12:31 PM
 * To change this template use File | Settings | File Templates.
 */

case class Coords(initialX: Int, initialY: Int) extends WithCoords {
  x = initialX
  y = initialY

  override def toString = "<Coords %d,%d>".format(x, y)
}