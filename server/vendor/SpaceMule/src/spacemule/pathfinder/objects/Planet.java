package spacemule.pathfinder.objects;

import spacemule.pathfinder.locations.Locatable;
import spacemule.pathfinder.locations.Location;
import spacemule.pathfinder.locations.SolarSystemPoint;

/**
 *
 * @author arturas
 */
public class Planet implements Locatable, SolarSystemObject {
  public int id, position, angle;
  public SolarSystem solarSystem;

  public Planet(int id, int position, int angle, SolarSystem solarSystem) {
    this.id = id;
    this.position = position;
    this.angle = angle;
    this.solarSystem = solarSystem;

    SolarSystemPoint.checkValidity(position, angle);
  }

  @Override
  public String toString() {
    return String.format("<Planet (id %d) in ss id %d @ %d,%d ", id,
      solarSystem.id,
      position, angle
    );
  }

  public int getId() {
    return id;
  }

  public Location toLocation() {
    return new Location(id, 
      spacemule.objects.Location.PLANET,
      null, null);
  }

  public int getSolarSystemId() {
    return solarSystem.id;
  }

  public SolarSystemPoint getSolarSystemPoint() {
    return new SolarSystemPoint(this);
  }
}
