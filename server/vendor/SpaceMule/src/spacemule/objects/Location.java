package spacemule.objects;

/**
 *
 * @author arturas
 */
public class Location {
  public static final int GALAXY = 0;
  public static final int SOLAR_SYSTEM = 1;
  public static final int PLANET = 2;
  public static final int UNIT = 3;
  /**
   * Special type of storing. locationId is planetId, and x, y references to
   * buildings x, y in the planet.
   */
  public static final int BUILDING = 4;
}
