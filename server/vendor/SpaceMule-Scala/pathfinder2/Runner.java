package spacemule.modules.pathfinder;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.Set;
import spacemule.modules.pathfinder.locations.GalaxyPoint;
import spacemule.modules.pathfinder.locations.Locatable;
import spacemule.modules.pathfinder.locations.Location;
import spacemule.modules.pathfinder.locations.SolarSystemPoint;
import spacemule.modules.pathfinder.objects.Planet;
import spacemule.modules.pathfinder.objects.SolarSystem;

/**
 *
 * @author arturas
 */
public class Runner {
  public static Map<String, Object> run(Map<String, Object> input) {
    SolarSystem sourceSs = readSolarSystem(input.get("from_solar_system"));
    SolarSystemPoint fromJumpgate = readSolarSystemPoint(sourceSs,
      input.get("from_jumpgate"));
    Locatable source = readLocatable(sourceSs, input.get("from"));

    SolarSystem targetSs = readSolarSystem(input.get("to_solar_system"));
    SolarSystemPoint targetJumpgate = readSolarSystemPoint(targetSs,
      input.get("to_jumpgate"));
    Locatable target = readLocatable(targetSs, input.get("to"));

    Set<Location> path = Pathfinder.find(
      source, target,
      fromJumpgate, sourceSs,
      targetJumpgate, targetSs
    );

    LinkedList<Map<String, Integer>> locations =
      new LinkedList<Map<String, Integer>>();
    for (Location location: path) {
      locations.add(location.toHash());
    }

    HashMap<String, Object> response = new HashMap<String, Object>();
    response.put("locations", locations);

    return response;
  }

  private static SolarSystem readSolarSystem(Object input) {
    if (input == null) {
      return null;
    }
    else {
      Map<String, Object> in = (Map<String, Object>) input;
      return new SolarSystem(
        (Integer) in.get("id"),
        (Integer) in.get("x"),
        (Integer) in.get("y"),
        (Integer) in.get("galaxy_id"),
        (Integer) in.get("orbit_count")
      );
    }
  }

  private static SolarSystemPoint readSolarSystemPoint(
      SolarSystem solarSystem,
      Object input) {
    if (solarSystem == null || input == null) {
      return null;
    }
    else {
      Map<String, Object> in = (Map<String, Object>) input;
      return new SolarSystemPoint(
        solarSystem,
        (Integer) in.get("x"),
        (Integer) in.get("y")
      );
    }
  }

  private static Locatable readLocatable(SolarSystem solarSystem,
      Object input) {
    Map<String, Object> in = (Map<String, Object>) input;
    int type = (Integer) in.get("type");
    
    switch (type) {
      case spacemule.modules.pathfinder.objects.Location.PLANET:
        return new Planet(
          (Integer) in.get("id"),
          (Integer) in.get("x"),
          (Integer) in.get("y"),
          solarSystem);
      case spacemule.modules.pathfinder.objects.Location.SOLAR_SYSTEM:
        return new SolarSystemPoint(
          solarSystem,
          (Integer) in.get("x"),
          (Integer) in.get("y")
        );
      case spacemule.modules.pathfinder.objects.Location.GALAXY:
        return new GalaxyPoint(
          (Integer) in.get("id"),
          (Integer) in.get("x"),
          (Integer) in.get("y")
        );
      default:
        return null;
    }
  }
}
