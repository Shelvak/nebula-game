/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.solar_system

import scalaj.collection.Implicits._
import org.jgrapht.alg.DijkstraShortestPath
import scala.collection.mutable.ListBuffer
import spacemule.modules.pmg.classes.geom.Coords

object Finder {
  def find(from: Coords, to: Coords): Seq[Coords] = {
    // Ensure to->from is the same path as from->to only reversed
    if (from.angle > to.angle) {
      // Drop the last one, because we reversed.
      // Then actually reverse the path and add our target as the last hop.
      return find(to, from).dropRight(1).reverse :+ to
    }

    val points = ListBuffer[Coords]()

    val path = DijkstraShortestPath.findPathBetween(
      SolarSystem.graph,
      from, to
    ).asScala

    path.foreach { edge => points += edge.to }

    return points
  }
}
