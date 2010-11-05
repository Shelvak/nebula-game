/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.solar_system

import scalaj.collection.Implicits._
import org.jgrapht.alg.DijkstraShortestPath
import scala.collection.mutable.ListBuffer
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.config.objects.Config

object Finder {
  def find(from: Coords, to: Coords): Seq[Coords] = {
    checkCoords("source", from)
    checkCoords("destination", to)

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
  
  private val maxPosition = Config.orbitCount

  private def checkCoords(description: String, coords: Coords) = {
    if (coords.position > maxPosition) {
      throw new IllegalArgumentException(
        "Coordinates %s for %s point had position bigger than max (%d)!".format(
          coords.toString, description, maxPosition
        )
      )
    }

    if (! SolarSystem.isAngleValid(coords.position, coords.angle)) {
      throw new IllegalArgumentException(
        "Coordinates %s for %s point had invalid angle!".format(
          coords.toString, description
        )
      )
    }
  }
}
