/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.solar_system

import org.jgrapht.graph.SimpleDirectedGraph
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.classes.geom.Coords

object SolarSystem {
  private val maxPosition = Config.orbitCount

  // We need directed graph here because when we search for the path,
  // we have no guarantees that source/target won't be swapped in
  // indirectional graph.
  val graph = new SimpleDirectedGraph[Coords, RetrievableEdge[Coords]](
    new RetrievableEdgeFactory[Coords]()
  )

  (0 to maxPosition).foreach { position =>
    val qpDegrees = quarterPointDegrees(position)
    val qpNumber = numOfQuarterPoints(position)
    
    // First and last point.
    var first: Coords = null
    var last: Coords = null

    // Draw a graph for solar system
    (0 to 3).foreach { quarter =>
      (0 until qpNumber).foreach { qpIndex =>
        val point = makePoint(position, quarter, qpIndex, qpDegrees)
        graph.addVertex(point)

        // Store first point if not stored yet.
        if (first == null) first = point

        // Connect to last point if it exists
        if (last != null) connect(last, point)

        // Store this point as last point
        last = point

        // Connect each point to his parents.
        // Position 0 does not have any parents.
        if (position > 0) {
          // Perpendiculars have one link to parent.
          if (point.angle % 90 == 0) {
            connect(Coords(position - 1, point.angle), point)
          }
          // Not perpendicular points link to two parent orbit points
          else {
            eachParentPoint(
              position, quarter, qpIndex, qpNumber
            ) { parentPoint => connect(parentPoint, point) }
          }
        }
      }
    }

    // Finally connect last point with the first one to complete the orbit
    connect(last, first)
  }

  private def numOfQuarterPoints(position: Int) = position + 1

  /**
   * How much one quarter point increases angle.
   */
  private def quarterPointDegrees(position: Int) =
    90 / numOfQuarterPoints(position)

  /**
   * Connects source and target bidirectionally.
   */
  private def connect(source: Coords, target: Coords) = {
    graph.addEdge(source, target);
    graph.addEdge(target, source);
  }

  /**
   * Returns a point from given parameters.
   */
  private def makePoint(position: Int, quarter: Int, qpIndex: Int,
                        qpDegrees: Int): Coords = {
    return Coords(position, quarter * 90 + qpIndex * qpDegrees)
  }

  /**
   * Yields each parent point.
   */
  private def eachParentPoint(position: Int, quarter: Int, qpIndex: Int,
                           qpNumber: Int)(block: (Coords) => Unit) = {
    // Number of degrees for QP in parent orbit.
    val qpDegrees = quarterPointDegrees(position - 1)

    // First point in parent, always in same quarter, always has smaller angle
    // than this point.
    block(makePoint(position - 1, quarter, qpIndex - 1, qpDegrees))

    // Second point in parent, may be in same quarter with greater angle or
    // it will be the first perpendicular point in next quarter.
    if (qpIndex == qpNumber - 1) {
      // Last point in this quarter. Link to parents next quarter first point.
      // Just check if this is not the last quarter, we need to wrap around
      // then.
      val nextQuarter = if (quarter == 3) 0 else quarter + 1
      block(makePoint(position - 1, nextQuarter, 0, qpDegrees))
    }
    else {
      // Link to point in parent with bigger angle than this one. Parent
      // point always is in same quarter as this one.
      block(makePoint(position - 1, quarter, qpIndex, qpDegrees))
    }
  }
}
