package spacemule.modules.pmg.objects

import solar_systems.{SpaceStation, Homeworld}
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.classes.geom.WithCoords
import util.Random
import collection.mutable.HashMap
import java.lang.IllegalStateException

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
    if (solarSystems.size == diameter * diameter) sys.error("Zone is full!")
    
    val spot = new Coords(Random.nextInt(diameter), Random.nextInt(diameter))

    while (true) {
      if (solarSystems.contains(spot)) {
        // This is effective because we only add a small percentage of solar
        // systems into zone, so most time this only takes 1 iteration.
        spot.x = Random.nextInt(diameter)
        spot.y = Random.nextInt(diameter)
      }
      else {
        return spot
      }
    }

    throw new IllegalStateException("Ne should never get here.")
  }

  /**
   * Adds new solar system to given coords. Also initializes it.
   */
  def addSolarSystem(solarSystem: SolarSystem, coords: Coords) {
    solarSystems(coords) = Some(solarSystem)
    solarSystem.createObjects()
    _hasNewPlayers = true
  }

  /**
   * Adds new homeworld to random free spot and puts its space station near it.
   */
  def addSolarSystem(homeworld: Homeworld, spaceStation: SpaceStation) {
    var spot = findFreeSpot()
    while (true) {
      (-1 to 1).foreach { x =>
        (-1 to 1).foreach { y =>
          val stationSpot = Coords(spot.x - x, spot.y - y)
          if (! solarSystems.contains(stationSpot)) {
            addSolarSystem(homeworld, spot)
            addSolarSystem(spaceStation, stationSpot)
            return
          }
        }
      }

      spot = findFreeSpot()
    }
  }

  /**
   * Marks spot as taken.
   */
  def markAsTaken(coords: Coords) = solarSystems(coords) = None

  /**
   * How much players are in this zone?
   */
  def playerCount =
    if (solarSystems.size == 0) 0
    else
      solarSystems.size - Config.freeSolarSystems.size - Config.wormholes.size -
        Config.miniBattlegrounds.size

  /**
   * Does this zone have new players we need to create?
   */
  def hasNewPlayers = _hasNewPlayers
}