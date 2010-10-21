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
    val points = ListBuffer[Coords]()

    val path = DijkstraShortestPath.findPathBetween(
      SolarSystem.graph,
      from, to
    ).asScala

    path.foreach { edge => points += edge.target }

    return points
  }
}
