package spacemule.pathfinder;

import spacemule.pathfinder.locations.Location;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import org.jgrapht.Graph;
import org.jgrapht.alg.DijkstraShortestPath;
import spacemule.pathfinder.locations.GalaxyPoint;
import spacemule.pathfinder.locations.Locatable;
import spacemule.pathfinder.locations.SolarSystemPoint;
import spacemule.pathfinder.objects.Planet;
import spacemule.pathfinder.objects.SolarSystemObject;

/**
 *
 * @author arturas
 */
public class Pathfinder {
  public static Set<Location> find(
          Locatable from,
          Locatable to,

          SolarSystemPoint fromJumpgate,
          spacemule.pathfinder.objects.SolarSystem fromSolarSystem,
          SolarSystemPoint toJumpgate,
          spacemule.pathfinder.objects.SolarSystem toSolarSystem) {

    LinkedHashSet<Location> locations =
            new LinkedHashSet<Location>();

    // If we are in planet - first step is to travel to solar system.
    if (from instanceof Planet) {
      Planet planet = (Planet) from;
      from = new SolarSystemPoint(planet);
      
      locations.add(from.toLocation());
    }

    // Now we are in solar system or galaxy for sure.
    // Let's try to look if we are in Solar System
    if (from instanceof SolarSystemPoint) {
      SolarSystemPoint fromPoint = (SolarSystemPoint) from;

      // Check out if we are in same SS or we have to travel to other one
      if (to instanceof SolarSystemObject) {
        SolarSystemObject toObject = (SolarSystemObject) to;

        // Yaaay, we have to travel in same SS!
        if (fromPoint.getSolarSystemId() == toObject.getSolarSystemId()) {
          // Travel inside the solar system
          travelInsideSS(locations, fromPoint, toObject);
          // Whew, we're done
          return locations;
        }
      }
      
      // Nop, outer hyperspace awaits us.

      // Travel to the jumpgate
      locations.addAll(
        findInSolarSystem(
          fromPoint,
          fromJumpgate
        )
      );
      
      // Switch traveling source to galaxy.
      from = new GalaxyPoint(fromPoint.solarSystem);
      // Add the point in galaxy.
      locations.add(from.toLocation());
    }

    // We are in galaxy! Whoa.
    GalaxyPoint fromGP = (GalaxyPoint) from;
    // Let's find out if we're just heading to some other point
    if (to instanceof GalaxyPoint) {
      GalaxyPoint toGP = (GalaxyPoint) to;

      // Travel there
      locations.addAll(
        findInGalaxy(fromGP, toGP)
      );
    }
    // Nop, we have to dive to the solar system
    else {
      // Travel to the SS we're jumping to
      locations.addAll(
        findInGalaxy(fromGP, toJumpgate.solarSystem.toGalaxyPoint())
      );

      // Add jumpgate.
      locations.add(toJumpgate.toLocation());

      // Travel inside the solar system
      SolarSystemObject toObject = (SolarSystemObject) to;
      travelInsideSS(locations, toJumpgate, toObject);
    }

    return locations;
  }

  /**
   * Travels from some point to solar system object (another point or
   * planet).
   *
   * @param locations
   * @param from
   * @param to
   */
  private static void travelInsideSS(Set<Location> locations,
          SolarSystemPoint from, SolarSystemObject to) {
    // travel to the point
    locations.addAll(findInSolarSystem(
            from,
            to.getSolarSystemPoint()
    ));

    // And if it's a planet - land there
    if (to instanceof Planet) {
      Planet planet = (Planet) to;
      locations.add(planet.toLocation());
    }
  }

  /**
   * Finds shortest path in galaxy. Uses straight lines!
   *
   * @param from
   * @param to
   * @return
   */
  private static Set<Location> findInGalaxy(
          GalaxyPoint from,
          GalaxyPoint to) {
    LinkedHashSet<Location> points = new LinkedHashSet<Location>();

    int xFrom = from.x, yFrom = from.y, xTo = to.x, yTo = to.y;
    // Increments that define direction
    int xIncrement = xTo > xFrom ? 1 : (xTo < xFrom ? -1 : 0);
    int yIncrement = yTo > yFrom ? 1 : (yTo < yFrom ? -1 : 0);

    // current x and y
    int currentX = xFrom, currentY = yFrom;
    points.add(
            new GalaxyPoint(from.galaxyId, currentX, currentY).toLocation()
    );
    
    // Travel!
    while (currentX != xTo || currentY != yTo) {
      currentX += xIncrement;
      currentY += yIncrement;
      points.add(
            new GalaxyPoint(from.galaxyId, currentX, currentY).toLocation()
      );

      // Set modifiers to 0 if we are in straight line in that axis.
      if (currentX == xTo) xIncrement = 0;
      if (currentY == yTo) yIncrement = 0;
    }

    return points;
  }

  /**
   * Finds path in solar system by OrbitPoints. Returns orbit points.
   *
   * @param graph
   * @param from
   * @param to
   * @return
   */
  private static Set<OrbitPoint> findInSolarSystem(
          Graph<OrbitPoint, RetrievableEdge<OrbitPoint>> graph,
          OrbitPoint from,
          OrbitPoint to) {
    LinkedHashSet<OrbitPoint> points = new LinkedHashSet<OrbitPoint>();

    List<RetrievableEdge<OrbitPoint>> path = DijkstraShortestPath.
      <OrbitPoint, RetrievableEdge<OrbitPoint>>findPathBetween(
      graph, from, to);

    for (RetrievableEdge<OrbitPoint> edge: path) {
      points.add(edge.getTarget());
    }

    return points;
  }

  /**
   * Finds path in solar system given SS points. Returns Locations.
   *
   * @param from
   * @param to
   * @return
   */
  private static Set<Location> findInSolarSystem(
          SolarSystemPoint from,
          SolarSystemPoint to) {
    SolarSystem solarSystem = new SolarSystem(from.solarSystem.orbitCount);

    Set<OrbitPoint> points = findInSolarSystem(
            solarSystem.createGraph(),
            solarSystem.findPoint(from),
            solarSystem.findPoint(to)
            );
    Set<Location> locations = new LinkedHashSet<Location>();

    for (OrbitPoint point: points) {
      locations.add(
              (new SolarSystemPoint(from.solarSystem, point)).toLocation()
      );
    }

    return locations;
  }
}
