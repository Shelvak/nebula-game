/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.solar_system

import org.jgrapht.graph.DefaultDirectedWeightedGraph
import scalaj.collection.Implicits._
import org.jgrapht.alg.DijkstraShortestPath
import spacemule.modules.pathfinder.objects.Hop
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.config.objects.Config

object Finder {
  def find(from: Coords, to: Coords, avoidablePoints: Option[Seq[Coords]]=None):
  Seq[Hop] = {
    checkCoords("source", from)
    checkCoords("destination", to)

    // Ensure to->from is the same path as from->to only reversed
    return if (from.angle > to.angle) {
      findPath(to, from, avoidablePoints).reverse.map { edge =>
        Hop(edge.from, SolarSystem.graph.getEdgeWeight(edge))
      }
    }
    else {
      findPath(from, to, avoidablePoints).map { edge =>
        Hop(edge.to, SolarSystem.graph.getEdgeWeight(edge))
      }
    }
  }

  private def findPath(from: Coords, to: Coords,
                       avoidablePoints: Option[Seq[Coords]]=None):
  Seq[RetrievableEdge[Coords]] = {
    val graph = avoidablePoints match {
      // If we have no points to remove - just return original SS graph
      case None => SolarSystem.graph
      // If we have some points to remove then return cloned graph without 
      // those points.
      case Some(points) => {
          val g = SolarSystem.graph.clone.asInstanceOf[
            DefaultDirectedWeightedGraph[Coords, RetrievableEdge[Coords]]
          ]
          points.foreach { point =>
            // Remove avoidable point if it is not our source or target.
            if (! (point == from || point == to)) g.removeVertex(point)
          }
          g
      }
    }

    val path = DijkstraShortestPath.findPathBetween(graph, from, to)
    // No path could be found, let's try without avoidable points.
    if (path == null) findPath(from, to) else path.asScala
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
