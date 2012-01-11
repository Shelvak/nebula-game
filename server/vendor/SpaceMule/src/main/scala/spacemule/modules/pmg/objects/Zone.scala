package spacemule.modules.pmg.objects

import solar_systems.{Homeworld}
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.classes.geom.WithCoords
import spacemule.modules.pmg.objects
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

object Zone {
  /**
   * Zone quarters.
   */
  val Quarters = IndexedSeq(
    Coords(1, 1), Coords(-1, 1), Coords(-1, -1), Coords(1, -1)
  )
  
  object SolarSystem {
    sealed abstract class Entry
    case object Existing extends Entry
    case class New(solarSystem: objects.SolarSystem) extends Entry
  }

  def apply(slot: Int, quarter: Int, diameter: Int) = {
    require(quarter >= 1 && quarter <= 4,
      "Quarter must be [1, 4], but was %d".format(quarter))
    require(slot >= 1, "Slot must be [1, inf) but was %d".format(slot))

    // Calculate diagonal number.
    val diagonal = ((math.sqrt(1 + 8 * slot) - 1) / 2).ceil

    // Calculate coordinates in Ist quarter.
    val x = (diagonal / 2 * (1 + diagonal) - slot).toInt
    val y = (x - diagonal).toInt

    // Transform to appropriate quarter.
    val transformation = Zone.Quarters(quarter - 1)
    new Zone(
      if (transformation.x == -1) x * -1 - 1 else x,
      if (transformation.y == -1) y * -1 - 1 else y,
      diameter
    )
  }
}

class Zone(_x: Int, _y: Int, val diameter: Int) extends WithCoords {
  /**
   * Does this zone have mature player solar systems? Mature player is one with
   * age greater than some value.
   */
  private[this] var hasMaturePlayers = false
  /**
   * Does this zone have new systems that are needed to create?
   */
  private[this] var hasNewSystems = false
  /**
   * How much players we have in this zone?
   */
  private[this] var playerCount = 0

  x = _x
  y = _y
  val solarSystems = new HashMap[Coords, Zone.SolarSystem.Entry]()

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
  def addSolarSystem(solarSystem: SolarSystem, coords: Coords,
                     playerSystem: Boolean) {
    solarSystems(coords) = Zone.SolarSystem.New(solarSystem)
    solarSystem.createObjects()

    hasNewSystems = true
    if (playerSystem) playerCount += 1
  }

  /**
   * Adds new homeworld to random free spot and puts its space station near it.
   */
  def addSolarSystem(homeworld: Homeworld) {
    var spot = findFreeSpot()
    addSolarSystem(homeworld, spot, true)
  }

  /**
   * Marks spot as taken.
   */
  def markAsTaken(coords: Coords, playerSystem: Boolean) {
    solarSystems(coords) = Zone.SolarSystem.Existing
    if (playerSystem) playerCount += 1
  }

  /**
   * Marks zone as having mature players. That makes it off limits for new
   * players.
   */
  def markAsMature() = hasMaturePlayers = true

  def isFull = hasMaturePlayers || playerCount >= Config.playersPerZone

  /**
   * Does this zone have new players we need to create?
   */
  def needsCreation = hasNewSystems

  def hasPlayers = playerCount > 0
}