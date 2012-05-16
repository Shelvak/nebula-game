package spacemule.modules.pmg.objects

import solar_systems.Homeworld
import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.classes.geom.WithCoords
import spacemule.modules.pmg.objects
import util.Random
import collection.mutable.HashMap
import java.lang.IllegalStateException
import spacemule.logging.Log

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

  def iterate[T](diameter: Int, startSlot: Int)(fun: (Zone) => Unit) {
    var zoneX = 0
    var zoneY = 0
    var slot = startSlot

    while (true) {
      // Shamelessly stolen from Mykolas, I don't really have much idea on what
      // is going on here.
      Zone.Quarters.shuffled.foreach { quarter =>
        // find logical coordinates in the first quarter
        val diag = ((math.sqrt(1 + 8 * slot) - 1) / 2).ceil
        val x = (diag / 2 * (1 + diag) - slot).toInt
        val y = (x - diag).toInt

        // transform logical coordinates to the quarter we need
        // taking into account the fact that we actually must calculate
        // coordinates of top-left corner in the
        // next step (-1 for x and -1 for y)
        zoneX = if (quarter.x == -1) -x - 1 else x
        zoneY = if (quarter.y == -1) -y - 1 else y

        val zone = new Zone(zoneX, zoneY, diameter)
        fun(zone)
      }

      slot += 1
    }
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
    val abs = absolute(coords)
    "<Zone(ss cnt: "+solarSystems.size+") @ rel:"+x+","+y+" abs:"+abs.x+","+
      abs.y+")>"
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
                     playerSystem: Boolean=false, skipExisting: Boolean=false) {
    if (solarSystems.contains(coords)) {
      if (skipExisting) return
      else throw new IllegalArgumentException(
        "Trying to add %s: %s already contains %s @ %s!".format(
          solarSystem, this, solarSystems(coords), coords
        )
      )
    }

    solarSystems(coords) = Zone.SolarSystem.New(solarSystem)
    Log.block(
      "Creating objects in "+solarSystem+" @ " + coords, level=Log.Debug
    ) { () => solarSystem.createObjects() }

    hasNewSystems = true
    if (playerSystem) playerCount += 1
  }

  /**
   * Adds new homeworld to random free spot and puts its space station near it.
   */
  def addSolarSystem(homeworld: Homeworld) {
    var spot = findFreeSpot()
    addSolarSystem(homeworld, spot, playerSystem = true)
  }

  /**
   * Marks spot as taken.
   */
  def markAsTaken(coords: Coords, playerSystem: Boolean) {
    require(
      coords.x >= 0 && coords.x <= diameter - 1 &&
      coords.y >= 0 && coords.y <= diameter - 1,
      "Both x and y for %s are required to be in [0..%d]".format(
        coords, diameter - 1
      )
    )
    solarSystems(coords) = Zone.SolarSystem.Existing
    if (playerSystem) playerCount += 1
  }

  /**
   * Marks zone as having mature players. That makes it off limits for new
   * players.
   */
  def markAsMature() = hasMaturePlayers = true

  def isMature = hasMaturePlayers

  def isFull = isMature || playerCount >= Config.playersPerZone

  /**
   * Does this zone have new players we need to create?
   */
  def needsCreation = hasNewSystems

  def hasPlayers = playerCount > 0
}