/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.solar_system

import scalaj.collection.Implicits._
import org.jgrapht.alg.DijkstraShortestPath
import spacemule.modules.pathfinder.objects.Hop
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.config.objects.Config

object Finder {
  def find(from: Coords, to: Coords): Seq[Hop] = {
    checkCoords("source", from)
    checkCoords("destination", to)

    // Ensure to->from is the same path as from->to only reversed
    return if (from.angle > to.angle) {
      findPath(to, from).reverse.map { edge =>
        Hop(edge.from, SolarSystem.graph.getEdgeWeight(edge))
      }
    }
    else {
      findPath(from, to).map { edge =>
        Hop(edge.to, SolarSystem.graph.getEdgeWeight(edge))
      }
    }
  }

  private def findPath(from: Coords, to: Coords):
  Seq[RetrievableEdge[Coords]] = {
    return DijkstraShortestPath.findPathBetween(
      SolarSystem.graph, from, to).asScala
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
