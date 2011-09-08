/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.galaxy

import scala.collection.mutable.ListBuffer
import spacemule.modules.pathfinder.objects.Hop
import spacemule.modules.pmg.classes.geom.Coords

object Finder {
  /**
   * Returns if this is a straight horizontal, vertical or diagonal line.
   */
  private def isStraightLine(first: Coords, second: Coords): Boolean = {
    val xDiff = second.x - first.x
    if (xDiff == 0) return true

    val yDiff = second.y - first.y
    val slope = yDiff.toFloat / xDiff
    return (slope == 0 || slope == 1)
  }

  def find(from: Coords, to: Coords): Seq[Hop] = {
    // Ensure to->from is the same path as from->to only reversed
    if (! isStraightLine(from, to) && from.x > to.x) {
      // Drop the last one, because we reversed.
      // Then actually reverse the path and add our target as the last hop.
      return find(to, from).dropRight(1).reverse :+ Hop(to)
    }

    val points = ListBuffer[Hop]()

    // Increments that define direction
    var xIncrement = to.x.compare(from.x)
    var yIncrement = to.y.compare(from.y)

    // current x and y
    var currentX = from.x
    var currentY = from.y

    // Travel!
    while (currentX != to.x || currentY != to.y) {
      currentX += xIncrement
      currentY += yIncrement
      points += Hop(Coords(currentX, currentY))

      // Set modifiers to 0 if we are in straight line in that axis.
      if (currentX == to.x) xIncrement = 0
      if (currentY == to.y) yIncrement = 0
    }

    return points
  }
}
