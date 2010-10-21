package spacemule.modules.pathfinder.locations;

import spacemule.modules.pathfinder.OrbitPoint;
import spacemule.modules.pathfinder.objects.Planet;
import spacemule.modules.pathfinder.objects.SolarSystem;
import spacemule.modules.pathfinder.objects.SolarSystemObject;

/**
 *
 * @author arturas
 */
public class SolarSystemPoint extends OrbitPoint implements Locatable,
        SolarSystemObject {
  public SolarSystem solarSystem;

  public SolarSystemPoint(SolarSystem solarSystem, int position, int angle) {
    super(position, angle, 0);
    checkValidity(position, angle);
    this.solarSystem = solarSystem;
  }

  @Override
  public String toString() {
    return String.format("<SSPoint %d,%d @ ss id %d>", position, angle,
      getId());
  }

  public static void checkValidity(int position, int angle) {
    if (position < 0)
      throw new IllegalArgumentException(
        "Position must be >= 0, but " + position + " was given."
      );

    if (! isAngleValid(position, angle))
      throw new IllegalArgumentException(
        "Angle was invalid for position " + position + "! " +
          angle + " was given."
      );
  }

  public static boolean isAngleValid(int position, int angle) {
    if (angle < 0 || angle >= 360)
      return false;
    
    int num_of_quarter_points = position + 1;
    int quarter_point_degrees = 90 / num_of_quarter_points;
    return (angle % 90) % quarter_point_degrees == 0;
  }

  public SolarSystemPoint(SolarSystem solarSystem, OrbitPoint point) {
    this(solarSystem, point.position, point.angle);
  }

  public SolarSystemPoint(Planet planet) {
    this(planet.solarSystem, planet.position, planet.angle);
  }

  public Location toLocation() {
    return new Location(solarSystem.id, 
      spacemule.modules.pathfinder.objects.Location.SOLAR_SYSTEM,
      position, angle);
  }

  public int getSolarSystemId() {
    return solarSystem.id;
  }

  public SolarSystemPoint getSolarSystemPoint() {
    return this;
  }

  public int getId() {
    return solarSystem.id;
  }
}
