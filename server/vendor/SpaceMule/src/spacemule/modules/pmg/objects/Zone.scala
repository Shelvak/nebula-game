package spacemule.modules.pmg.objects

import scala.collection.mutable.HashSet
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
  /**
   * Player ids that are in that zone.
   */
  private val playerIds = new HashSet[Int]()
  /**
   * Number of players whose ids we still don't know
   */
  private var playersWithoutId = 0

  def coords = Coords(x, y)

  def absolute(coords: Coords): Coords = {
    return Coords(x * diameter + coords.x, y * diameter + coords.y)
  }

  override def toString(): String = {
    "<Zone(%d) @ %d,%d>".format(solarSystems.size, x, y)
  }

  def findFreeSpot(): Coords = {
    val spot = new Coords(Random.nextInt(diameter), Random.nextInt(diameter))

    if (solarSystems.size == diameter * diameter) error("Zone is full!")

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

  def addSolarSystem(solarSystem: SolarSystem, coords: Coords): scala.Unit = {
    solarSystems(coords) = solarSystem
    solarSystem.createObjects()
  }

  def addSolarSystem(solarSystem: SolarSystem): scala.Unit = {
    addSolarSystem(solarSystem, findFreeSpot())
  }

  /**
   * Register player id as existing in this zone.
   */
  def registerPlayer(id: Option[Int]): scala.Unit = id match {
    case Some(id) => playerIds += id
    case None => playersWithoutId += 1
  }

  def registerPlayer(p: Player): scala.Unit = registerPlayer(None)
  def registerPlayer(id: Int): scala.Unit = registerPlayer(Some(id))

  /**
   * How much players are in this zone?
   */
  def playerCount = playerIds.size + playersWithoutId

  /**
   * Does this zone have new players we need to create?
   */
  def hasNewPlayers = playersWithoutId > 0
}