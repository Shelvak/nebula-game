package spacemule.modules.pmg.objects

import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.classes.geom.WithCoords
import util.Random
import collection.mutable.HashMap

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 11:38:27 AM
 * To change this template use File | Settings | File Templates.
 */

class Zone(_x: Int, _y: Int, val diameter: Int)
        extends WithCoords {
  x = _x
  y = _y
  val solarSystems = new HashMap[Coords, SolarSystem]()

  override def toString(): String = {
    "<Zone(%d) @ %d,%d>".format(solarSystems.size, x, y)
  }

  def findFreeSpot():Coords = {
    val spot = new Coords(Random.nextInt(diameter), Random.nextInt(diameter))
    var found = false
    while (! found) {
      if (solarSystems.contains(spot)) {
        // This is effective because we only add a small percentage of solar
        // systems into zone, so most time this only takes 1 iteration.
        spot.x = Random.nextInt(diameter)
        spot.y = Random.nextInt(diameter)
      }
      else {
        found = true
      }
    }

    spot
  }

  def addSolarSystem(solarSystem: SolarSystem) = {
    solarSystems(findFreeSpot()) = solarSystem
    solarSystem.createObjects()
  }
}