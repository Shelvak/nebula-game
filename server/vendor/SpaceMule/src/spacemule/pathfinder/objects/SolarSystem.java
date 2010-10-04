package spacemule.pathfinder.objects;

import spacemule.pathfinder.locations.GalaxyPoint;

/**
 *
 * @author arturas
 */
public class SolarSystem {
  public int id, x, y, galaxyId, orbitCount;

  public SolarSystem(int id, int x, int y, int galaxyId, int orbitCount) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.galaxyId = galaxyId;
    this.orbitCount = orbitCount;
  }

  public GalaxyPoint toGalaxyPoint() {
    return new GalaxyPoint(this);
  }
}
