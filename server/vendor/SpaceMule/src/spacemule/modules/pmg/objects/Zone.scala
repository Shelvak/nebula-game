package spacemule.modules.pmg.objects

import spacemule.modules.config.objects.Config
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
  val solarSystems = new HashMap[Coords, Option[SolarSystem]]()

  /**
   * Does this Zone have solar systems with new players?
   */
  private var _hasNewPlayers = false

  def coords = Coords(x, y)

  def absolute(coords: Coords): Coords = {
    return Coords(x * diameter + coords.x, y * diameter + coords.y)
  }

  override def toString(): String = {
    "<Zone(%d) @ %d,%d>".format(solarSystems.size, x, y)
  }

  def findFreeSpot(): Coords = {
    if (solarSystems.size == diameter * diameter) error("Zone is full!")
    
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

  /**
   * Adds new solar system to given coords. Also initializes it.
   */
  def addSolarSystem(solarSystem: SolarSystem, coords: Coords): scala.Unit = {
    solarSystems(coords) = Some(solarSystem)
    solarSystem.createObjects()
    _hasNewPlayers = true
  }

  /**
   * Adds new solar system to random free spot.
   */
  def addSolarSystem(solarSystem: SolarSystem): scala.Unit = {
    addSolarSystem(solarSystem, findFreeSpot())
  }

  /**
   * Marks spot as taken.
   */
  def markAsTaken(coords: Coords) = solarSystems(coords) = None

  /**
   * How much players are in this zone?
   */
  def playerCount = if (solarSystems.size == 0) 0 else solarSystems.size -
    Config.resourceSolarSystems.size - Config.expansionSolarSystems.size -
    Config.wormholes.size

  /**
   * Does this zone have new players we need to create?
   */
  def hasNewPlayers = _hasNewPlayers
}