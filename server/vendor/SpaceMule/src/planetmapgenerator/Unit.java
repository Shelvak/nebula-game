package planetmapgenerator;

import spacemule.objects.Location;

/**
 * Represents unit sitting in the Planet in some building.
 *
 * @author arturas
 */
public class Unit implements SqlData {
  int galaxyId, locationX, locationY, flank;
  String type;

  public Unit(String type, int flank, int locationX, int locationY) {
    this.locationX = locationX;
    this.locationY = locationY;
    this.flank = flank;
    this.type = type;
  }

  public static int getHp(String name) {
    return Config.getInt("units." + name + ".hp");
  }

  public static String columns() {
    return "`location_id`, `location_type`, `location_x`, `location_y`, " +
            "`galaxy_id`, `type`, `level`, `hp`, `flank`";
  }


  public String toValues(int planetId) {
    return String.format("%d, %d, %d, %d, %d, '%s', %d, %d, %d",
            planetId,
            Location.BUILDING,
            locationX,
            locationY,
            galaxyId,
            Config.camelcase(type),
            1,
            getHp(type),
            flank
    );
  }

}
