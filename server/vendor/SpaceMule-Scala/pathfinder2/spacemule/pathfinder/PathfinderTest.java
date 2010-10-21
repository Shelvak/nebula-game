/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package spacemule.pathfinder;

import java.util.LinkedHashSet;
import java.util.Set;
import org.junit.Test;
import static org.junit.Assert.*;
import spacemule.pathfinder.locations.Locatable;
import spacemule.pathfinder.locations.Location;
import spacemule.pathfinder.locations.SolarSystemPoint;
import spacemule.pathfinder.objects.Planet;
import spacemule.pathfinder.objects.SolarSystem;

/**
 *
 * @author arturas
 */
public class PathfinderTest {
  @Test
  public void testFindPlanetToSameSSDirect() {
    SolarSystemPoint fromJumpgate = null;
    SolarSystem fromSolarSystem = new SolarSystem(10, 0, 0, 100, 5);
    SolarSystemPoint toJumpgate = null;
    SolarSystem toSolarSystem = null;

    Locatable from = new Planet(1, 1, 0, fromSolarSystem);
    Locatable to = new SolarSystemPoint(fromSolarSystem, 2, 0);

    Set expResult = new LinkedHashSet();
    expResult.add(new Location(fromSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      1, 0));
    expResult.add(new Location(fromSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      2, 0));

    Set result = Pathfinder.find(from, to, fromJumpgate, fromSolarSystem, toJumpgate, toSolarSystem);
    assertArrayEquals(expResult.toArray(), result.toArray());
  }

  @Test
  public void testPlanetToSSCrash() {
    //{"from_jumpgate":null ,"from":{"type":2,"y":315,"id":2,"x":1},
    //"action":"find_path","to":{"type":1,"y":225,"id":1,"x":1},
    //"from_solar_system":{"y":0,"orbit_count":7,"galaxy_id":1,"id":1,"x":0},
    //"to_jumpgate": null,
    //"to_solar_system":{"y":0,"orbit_count":7,"galaxy_id":1,"id":1,"x":0}}

    SolarSystemPoint fromJumpgate = null;
    SolarSystem fromSolarSystem = new SolarSystem(1, 0, 0, 1, 7);
    SolarSystemPoint toJumpgate = null;
    SolarSystem toSolarSystem = new SolarSystem(1, 0, 0, 1, 7);

    Locatable from = new Planet(2, 1, 315, fromSolarSystem);
    Locatable to = new SolarSystemPoint(toSolarSystem, 1, 225);

    Pathfinder.find(from, to, fromJumpgate, fromSolarSystem, toJumpgate,
      toSolarSystem);
  }

  @Test
  public void testFindPlanetToSameSSPlanetDirect() {

    SolarSystemPoint fromJumpgate = null;
    SolarSystem fromSolarSystem = new SolarSystem(10, 0, 0, 100, 5);
    SolarSystemPoint toJumpgate = null;
    SolarSystem toSolarSystem = null;

    Locatable from = new Planet(1, 1, 0, fromSolarSystem);
    Locatable to = new Planet(2, 3, 0, fromSolarSystem);

    Set expResult = new LinkedHashSet();
    expResult.add(new Location(fromSolarSystem.id, spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      1, 0));
    expResult.add(new Location(fromSolarSystem.id, spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      2, 0));
    expResult.add(new Location(fromSolarSystem.id, spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      3, 0));
    expResult.add(new Location(2, spacemule.pathfinder.objects.Location.PLANET,
      null, null));

    Set result = Pathfinder.find(from, to, fromJumpgate, fromSolarSystem, toJumpgate, toSolarSystem);
    assertArrayEquals(expResult.toArray(), result.toArray());
  }

  @Test
  public void testFindSSToSameSS() {
    SolarSystemPoint fromJumpgate = null;
    SolarSystem fromSolarSystem = new SolarSystem(10, 0, 0, 100, 5);
    SolarSystemPoint toJumpgate = null;
    SolarSystem toSolarSystem = null;

    Locatable from = new SolarSystemPoint(fromSolarSystem, 1, 0);
    Locatable to = new SolarSystemPoint(fromSolarSystem, 3, 0);

    Set expResult = new LinkedHashSet();
    expResult.add(new Location(fromSolarSystem.id, spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      2, 0));
    expResult.add(new Location(fromSolarSystem.id, spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      3, 0));

    Set result = Pathfinder.find(from, to, fromJumpgate, fromSolarSystem, toJumpgate, toSolarSystem);
    assertArrayEquals(expResult.toArray(), result.toArray());
  }

  @Test
  public void testFindSSToSameSSInwards() {
    SolarSystemPoint fromJumpgate = null;
    SolarSystem fromSolarSystem = new SolarSystem(10, 0, 0, 100, 5);
    SolarSystemPoint toJumpgate = null;
    SolarSystem toSolarSystem = null;

    Locatable from = new SolarSystemPoint(fromSolarSystem, 3, 0);
    Locatable to = new SolarSystemPoint(fromSolarSystem, 1, 0);

    Set expResult = new LinkedHashSet();
    expResult.add(new Location(fromSolarSystem.id, spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      2, 0));
    expResult.add(new Location(fromSolarSystem.id, spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      1, 0));

    Set result = Pathfinder.find(from, to, fromJumpgate, fromSolarSystem, toJumpgate, toSolarSystem);
    assertArrayEquals(expResult.toArray(), result.toArray());
  }

  @Test
  public void testFindPointToSSPlanetDirect() {
    int galaxyId = 100;
    SolarSystem fromSolarSystem = new SolarSystem(10, 0, 0, galaxyId, 4);
    SolarSystemPoint fromJumpgate = null;
    SolarSystem toSolarSystem = null;
    SolarSystemPoint toJumpgate = null;

    Locatable from = new SolarSystemPoint(fromSolarSystem, 3, 90);
    Locatable to = new Planet(2, 1, 90, fromSolarSystem);

    Set expResult = new LinkedHashSet();
    expResult.add(new Location(fromSolarSystem.id, spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      2, 90));
    expResult.add(new Location(fromSolarSystem.id, spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      1, 90));
    expResult.add(new Location(to.getId(), spacemule.pathfinder.objects.Location.PLANET,
      null, null));

    Set result = Pathfinder.find(from, to, fromJumpgate, fromSolarSystem, toJumpgate, toSolarSystem);
    assertArrayEquals(expResult.toArray(), result.toArray());
  }

  @Test
  public void testFindPointToSSPlanetAlmostDirect() {
    int galaxyId = 100;
    SolarSystem fromSolarSystem = new SolarSystem(10, 0, 0, galaxyId, 2);
    SolarSystemPoint fromJumpgate = null;
    SolarSystem toSolarSystem = null;
    SolarSystemPoint toJumpgate = null;

    Locatable from = new SolarSystemPoint(fromSolarSystem, 1, 180);
    Locatable to = new Planet(2, 0, 0, fromSolarSystem);

    Set expResult = new LinkedHashSet();
    expResult.add(new Location(fromSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      0, 180));
    expResult.add(new Location(fromSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      0, 270));
    expResult.add(new Location(fromSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      0, 0));
    expResult.add(new Location(2, spacemule.pathfinder.objects.Location.PLANET,
      null, null));

    Set result = Pathfinder.find(from, to, fromJumpgate, fromSolarSystem, toJumpgate, toSolarSystem);
    assertArrayEquals(expResult.toArray(), result.toArray());
  }

  @Test
  public void testFindSSCircleCW() {
    int galaxyId = 100;
    SolarSystem fromSolarSystem = new SolarSystem(10, 0, 0, galaxyId, 2);
    SolarSystemPoint fromJumpgate = null;
    SolarSystem toSolarSystem = null;
    SolarSystemPoint toJumpgate = null;

    Locatable from = new SolarSystemPoint(fromSolarSystem, 0, 90);
    Locatable to = new SolarSystemPoint(fromSolarSystem, 0, 0);

    Set expResult = new LinkedHashSet();
    expResult.add(new Location(fromSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      0, 0));

    Set result = Pathfinder.find(from, to, fromJumpgate, fromSolarSystem, toJumpgate, toSolarSystem);
    assertArrayEquals(expResult.toArray(), result.toArray());
  }

  @Test
  public void testFindSSCircleCCW() {
    int galaxyId = 100;
    SolarSystem fromSolarSystem = new SolarSystem(10, 0, 0, galaxyId, 2);
    SolarSystemPoint fromJumpgate = null;
    SolarSystem toSolarSystem = null;
    SolarSystemPoint toJumpgate = null;

    Locatable from = new SolarSystemPoint(fromSolarSystem, 0, 270);
    Locatable to = new SolarSystemPoint(fromSolarSystem, 0, 0);

    Set expResult = new LinkedHashSet();
    expResult.add(new Location(fromSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      0, 0));

    Set result = Pathfinder.find(from, to, fromJumpgate, fromSolarSystem, toJumpgate, toSolarSystem);
    assertArrayEquals(expResult.toArray(), result.toArray());
  }

  @Test
  public void testFindPointToPointAlmostDirect() {
    int galaxyId = 100;
    SolarSystem fromSolarSystem = new SolarSystem(10, 0, 0, galaxyId, 4);
    SolarSystemPoint fromJumpgate = null;
    SolarSystem toSolarSystem = null;
    SolarSystemPoint toJumpgate = null;

    Locatable from = new SolarSystemPoint(fromSolarSystem, 2, 90);
    Locatable to = new SolarSystemPoint(fromSolarSystem, 0, 0);

    Set expResult = new LinkedHashSet();
    expResult.add(new Location(fromSolarSystem.id, spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      1, 90));
    expResult.add(new Location(fromSolarSystem.id, spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      0, 90));
    expResult.add(new Location(fromSolarSystem.id, spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      0, 0));

    Set result = Pathfinder.find(from, to, fromJumpgate, fromSolarSystem, toJumpgate, toSolarSystem);
    assertArrayEquals(expResult.toArray(), result.toArray());
  }

  @Test
  public void testFindPointToSSPlanet() {
    int galaxyId = 100;
    SolarSystem fromSolarSystem = new SolarSystem(10, 0, 0, galaxyId, 3);
    SolarSystemPoint fromJumpgate = null;
    SolarSystem toSolarSystem = null;
    SolarSystemPoint toJumpgate = null;

    Locatable from = new SolarSystemPoint(fromSolarSystem, 2, 90);
    Locatable to = new Planet(2, 0, 0, fromSolarSystem);

    Set expResult = new LinkedHashSet();
    expResult.add(new Location(fromSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      1, 90));
    expResult.add(new Location(fromSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      0, 90));
    expResult.add(new Location(fromSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      0, 0));
    expResult.add(new Location(2, spacemule.pathfinder.objects.Location.PLANET,
      null, null));

    Set result = Pathfinder.find(from, to, fromJumpgate, fromSolarSystem, toJumpgate, toSolarSystem);
    assertArrayEquals(expResult.toArray(), result.toArray());
  }

  @Test
  public void testFindPlanetToOtherSSPlanet() {
    int galaxyId = 100;
    SolarSystem fromSolarSystem = new SolarSystem(10, 0, 0, galaxyId, 2);
    SolarSystemPoint fromJumpgate =
      new SolarSystemPoint(fromSolarSystem, 1, 90);
    SolarSystem toSolarSystem = new SolarSystem(11, 3, 2, galaxyId, 2);
    SolarSystemPoint toJumpgate =
      new SolarSystemPoint(toSolarSystem, 1, 90);

    Locatable from = new Planet(1, 0, 0, fromSolarSystem);
    Locatable to = new Planet(2, 0, 0, toSolarSystem);

    Set expResult = new LinkedHashSet();
    expResult.add(new Location(fromSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      0, 0));
    expResult.add(new Location(fromSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      0, 90));
    expResult.add(new Location(fromSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      1, 90));
    expResult.add(new Location(galaxyId,
      spacemule.pathfinder.objects.Location.GALAXY, 0, 0));
    expResult.add(new Location(galaxyId,
      spacemule.pathfinder.objects.Location.GALAXY, 1, 1));
    expResult.add(new Location(galaxyId,
      spacemule.pathfinder.objects.Location.GALAXY, 2, 2));
    expResult.add(new Location(galaxyId,
      spacemule.pathfinder.objects.Location.GALAXY, 3, 2));
    expResult.add(new Location(toSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      1, 90));
    expResult.add(new Location(toSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      1, 45));
    expResult.add(new Location(toSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      0, 0));
    expResult.add(new Location(2, spacemule.pathfinder.objects.Location.PLANET,
      null, null));

    Set result = Pathfinder.find(from, to, fromJumpgate, fromSolarSystem, toJumpgate, toSolarSystem);
    assertArrayEquals(expResult.toArray(), result.toArray());
  }

  @Test
  public void testFindPlanetToOtherSSPlanet2() {
    int galaxyId = 100;
    SolarSystem fromSolarSystem = new SolarSystem(10, -1, 0, galaxyId, 3);
    SolarSystemPoint fromJumpgate =
      new SolarSystemPoint(fromSolarSystem, 2, 0);
    SolarSystem toSolarSystem = new SolarSystem(11, 1, 0, galaxyId, 3);
    SolarSystemPoint toJumpgate =
      new SolarSystemPoint(toSolarSystem, 2, 0);

    int fromPlanetId = 1;
    int toPlanetId = 2;
    Locatable from = new Planet(fromPlanetId, 1, 0, fromSolarSystem);
    Locatable to = new Planet(toPlanetId, 1, 0, toSolarSystem);

    Set expResult = new LinkedHashSet();
    expResult.add(new Location(fromSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      1, 0));
    expResult.add(new Location(fromSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      2, 0));
    expResult.add(new Location(galaxyId, 
      spacemule.pathfinder.objects.Location.GALAXY, -1, 0));
    expResult.add(new Location(galaxyId,
      spacemule.pathfinder.objects.Location.GALAXY, 0, 0));
    expResult.add(new Location(galaxyId,
      spacemule.pathfinder.objects.Location.GALAXY, 1, 0));
    expResult.add(new Location(toSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      2, 0));
    expResult.add(new Location(toSolarSystem.id,
      spacemule.pathfinder.objects.Location.SOLAR_SYSTEM,
      1, 0));
    expResult.add(new Location(toPlanetId, spacemule.pathfinder.objects.Location.PLANET,
      null, null));

    Set result = Pathfinder.find(from, to, fromJumpgate, fromSolarSystem,
      toJumpgate, toSolarSystem);
    assertArrayEquals(expResult.toArray(), result.toArray());
  }

}
