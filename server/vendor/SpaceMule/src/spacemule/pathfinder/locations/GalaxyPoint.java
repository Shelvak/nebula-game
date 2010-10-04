package spacemule.pathfinder.locations;

import spacemule.pathfinder.objects.SolarSystem;

/**
 *
 * @author arturas
 */
public class GalaxyPoint implements Locatable {
  public int galaxyId, x, y;

  public GalaxyPoint(int galaxyId, int x, int y) {
    this.galaxyId = galaxyId;
    this.x = x;
    this.y = y;
  }

  public GalaxyPoint(SolarSystem solarSystem) {
    this(solarSystem.galaxyId, solarSystem.x, solarSystem.y);
  }

  public Location toLocation() {
    return new Location(galaxyId, 
      spacemule.objects.Location.GALAXY, x, y);
  }

  public int getId() {
    return galaxyId;
  }
}
