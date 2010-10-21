/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.galaxy

import scala.collection.mutable.ListBuffer
import spacemule.modules.pmg.classes.geom.Coords

object Finder {
  def find(from: Coords, to: Coords): Seq[Coords] = {
    // Ensure to->from is the same path as from->to only reversed
    if (from.x > to.x) {
      return find(to, from).reverse
    }

    val points = ListBuffer[Coords]()

    // Increments that define direction
    var xIncrement = to.x.compare(from.x)
    var yIncrement = to.y.compare(from.y)

    // current x and y
    var currentX = from.x
    var currentY = from.y
    points += Coords(currentX, currentY)

    // Travel!
    while (currentX != to.x || currentY != to.y) {
      currentX += xIncrement
      currentY += yIncrement
      points += Coords(currentX, currentY)

      // Set modifiers to 0 if we are in straight line in that axis.
      if (currentX == to.x) xIncrement = 0
      if (currentY == to.y) yIncrement = 0
    }

    return points
  }
}
