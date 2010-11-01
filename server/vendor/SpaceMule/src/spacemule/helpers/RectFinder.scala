package spacemule.helpers

import java.awt.Rectangle
import scala.collection.mutable.HashSet
import spacemule.helpers.Converters._
import spacemule.modules.pmg.classes.geom.area.Area

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 14, 2010
 * Time: 4:25:52 PM
 * To change this template use File | Settings | File Templates.
 */

class RectFinder(initialWidth: Int, initialHeight: Int) {
  def this(area: Area) = this(area.width, area.height)

  private val rectangles = HashSet[Rectangle]()
  rectangles += new Rectangle(0, 0, initialWidth, initialHeight)

  /**
   * array of failed rectangles as areas
   */
  private val failed = HashSet[Area]();

  def findPlace(area: Area): Option[Rectangle] = {
    return findPlace(area.width, area.height)
  }

  def findPlace(width: Int, height: Int): Option[Rectangle] = {
    val area = Area(width, height)

    // check if object rect meets minimal requirements
    if (failed.contains(area)) {
      return None
    }

    // find the smallest size empty rect, which can accept this object rect
    return minEmptyRectangle(width, height) match {
      // place object in empty rect if found and return its coordinates
      case Some(rectangle: Rectangle) => Some[Rectangle](
        placeObject(rectangle, area)
      )
      case None => {
        failed += area

        None
      }
    }
  }

  private def minEmptyRectangle(width: Int, height: Int): Option[Rectangle] = {
    var minRectangle: Option[Rectangle] = None

    for (rectangle <- rectangles) {
      if (
        rectangle.width >= width &&
        rectangle.height >= height &&
        (
          minRectangle match {
            case Some(mr: Rectangle) => mr.area > rectangle.area
            case None => true
          }
        )
      ) {
        minRectangle = Some[Rectangle](rectangle)
      }
    }

    return minRectangle
  }

  /**
   * Places object defined by area into rectangle defined by zone. 
   */
  private def placeObject(zone: Rectangle, area: Area): Rectangle = {
    val x = (zone.x to (zone.x + zone.width - area.width)).random
    val y = (zone.y to (zone.y + zone.height - area.height)).random
    val obj = new Rectangle(x, y, area.width, area.height)
    splitAllThatCollidesWith(obj)

    return obj
  }

  private def splitAllThatCollidesWith(rect: Rectangle) = {
    rectangles.filter(
      emptyRectangle => emptyRectangle.intersects(rect)
    ).foreach { emptyRectangle => split(emptyRectangle, rect) }
  }

  private def split(rect: Rectangle, mask: Rectangle) = {
    // REMOVE old one
    rectangles -= rect
    // LEFT
    if (mask.x > rect.x) {
      rectangles += new Rectangle(rect.x, rect.y, mask.x - rect.x, rect.height)
    }
    // RIGHT
    if (mask.x + mask.width < rect.x + rect.width) {
      rectangles += new Rectangle(mask.x + mask.width, rect.y,
        rect.x + rect.width - (mask.x + mask.width), rect.height)
    }
    // TOP
    if (mask.y > rect.y) {
      rectangles += new Rectangle(rect.x, rect.y, rect.width, mask.y - rect.y)
    }
    // BOTTOM
    if (mask.y + mask.height < rect.y + rect.height) {
      rectangles += new Rectangle(rect.x, mask.y + mask.height,
        rect.width, rect.y + rect.height - (mask.y + mask.height))
    }
  }
}