package spacemule.pathfinder;

import java.util.Set;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import spacemule.JSONUtils;
import spacemule.pathfinder.locations.GalaxyPoint;
import spacemule.pathfinder.locations.Locatable;
import spacemule.pathfinder.locations.Location;
import spacemule.pathfinder.locations.SolarSystemPoint;
import spacemule.pathfinder.objects.Planet;
import spacemule.pathfinder.objects.SolarSystem;

/**
 *
 * @author arturas
 */
public class Runner {
  public static JSONObject run(JSONObject input) {
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

    JSONArray locations = new JSONArray();
    for (Location location: path) {
      locations.add(location.toJSON());
    }

    JSONObject response = new JSONObject();
    response.put("locations", locations);

    return response;
  }

  private static SolarSystem readSolarSystem(Object input) {
    if (input == null) {
      return null;
    }
    else {
      JSONObject json = (JSONObject) input;
      return new SolarSystem(
        JSONUtils.getInt(json, "id"),
        JSONUtils.getInt(json, "x"),
        JSONUtils.getInt(json, "y"),
        JSONUtils.getInt(json, "galaxy_id"),
        JSONUtils.getInt(json, "orbit_count")
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
      JSONObject json = (JSONObject) input;
      return new SolarSystemPoint(
        solarSystem,
        JSONUtils.getInt(json, "x"),
        JSONUtils.getInt(json, "y")
      );
    }
  }

  private static Locatable readLocatable(SolarSystem solarSystem,
      Object input) {
    JSONObject json = (JSONObject) input;
    int type = JSONUtils.getInt(json, "type");
    
    switch (type) {
      case spacemule.objects.Location.PLANET:
        return new Planet(
          JSONUtils.getInt(json, "id"),
          JSONUtils.getInt(json, "x"),
          JSONUtils.getInt(json, "y"),
          solarSystem);
      case spacemule.objects.Location.SOLAR_SYSTEM:
        return new SolarSystemPoint(
          solarSystem,
          JSONUtils.getInt(json, "x"),
          JSONUtils.getInt(json, "y")
        );
      case spacemule.objects.Location.GALAXY:
        return new GalaxyPoint(
          JSONUtils.getInt(json, "id"),
          JSONUtils.getInt(json, "x"),
          JSONUtils.getInt(json, "y")
        );
      default:
        return null;
    }
  }
}
