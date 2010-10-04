package spacemule.pathfinder;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import org.jgrapht.DirectedGraph;
import org.jgrapht.Graph;
import org.jgrapht.graph.SimpleDirectedGraph;
import spacemule.pathfinder.RetrievableEdge;
import spacemule.pathfinder.locations.SolarSystemPoint;

/**
 *
 * @author arturas
 */
public class SolarSystem implements Iterable<Orbit> {
  private List<Orbit> orbits;

  public SolarSystem(int orbitCount) {
    orbits = new ArrayList<Orbit>(orbitCount);

    for (int index = 0; index < orbitCount; index++) {
      orbits.add(new Orbit(index));
    }
  }

  public Orbit getOrbit(int position) {
    return orbits.get(position);
  }

  public OrbitPoint getPoint(int orbitPosition, int pointIndex) {
    return getOrbit(orbitPosition).getPointByIndex(pointIndex);
  }

  public Iterator<Orbit> iterator() {
    return orbits.iterator();
  }

  private void addEdge(Graph<OrbitPoint, RetrievableEdge<OrbitPoint>> graph,
      OrbitPoint from, OrbitPoint to) {
    graph.addEdge(from, to);
    graph.addEdge(to, from);
  }

  public Graph<OrbitPoint, RetrievableEdge<OrbitPoint>>
          createGraph() {
    // We need directed graph here because when we search for the path,
    // we have no guarantees that source/target won't be swapped in
    // indirectional graph.
    DirectedGraph<OrbitPoint, RetrievableEdge<OrbitPoint>> g =
            new SimpleDirectedGraph<OrbitPoint, RetrievableEdge<OrbitPoint>>
            (new EdgeFactory<OrbitPoint, RetrievableEdge<OrbitPoint>>());

    for (Orbit orbit : this) {
      OrbitPoint lastPoint = null;

      for (OrbitPoint point : orbit) {
        g.addVertex(point);

        // Create a circle around the orbit
        if (lastPoint != null) {
          addEdge(g, lastPoint, point);
        }
        lastPoint = point;

        // Link with parent if we can.
        int orbitPosition = orbit.getPosition();
        if (orbitPosition != 0) {
          Orbit parent = this.getOrbit(orbitPosition - 1);

          // Set perpendicular points and add edges.
          if (point.angle % 90 == 0) {
            addEdge(g, parent.getPointByAngle(point.angle), point);
          }
          // Not perpendicular point with index n link to two parent
          // orbit points with indexes m - 1 and m,
          // where m = n - perpendicularsSkipped
          else {
            // Number of perpendicular points skipped.
            int perpendicularsSkipped = point.angle / 90;
            int parentIndex = point.index - perpendicularsSkipped;

            addEdge(g, parent.getPointByIndex(parentIndex - 1), point);

            // If it's the last point we need to link it to point 0
            // in parent
            if (parentIndex > parent.getPointMaxIndex()) {
              addEdge(g, parent.getPointByIndex(0), point);
            } else {
              addEdge(g, parent.getPointByIndex(parentIndex), point);
            }
          }
        }
      }

      addEdge(g, lastPoint, orbit.getPointByIndex(0));
    }

    return g;
  }

  OrbitPoint findPoint(SolarSystemPoint ssPoint) {
    return getOrbit(ssPoint.position).getPointByAngle(ssPoint.angle);
  }
}
