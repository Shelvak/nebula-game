package spacemule.modules.pmg.objects

import scala.collection.mutable.HashMap
import solar_systems.{Resource, Expansion, Homeworld}
import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.solar_systems.Wormhole

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 11:36:16 AM
 * To change this template use File | Settings | File Templates.
 */

class Galaxy(val id: Int) {
  val zoneDiameter = Config.zoneDiameter
  val expansionSystems = Config.expansionSolarSystems
  val resourceSystems = Config.resourceSolarSystems
  val wormholes = Config.wormholes
  val zones = new HashMap[Coords, Zone]()
  val shifts = IndexedSeq(-1, 0, 1)

  def addExistingSS(x: Int, y: Int): scala.Unit = {
    // For some reason -1 / 2 == 0 instead of -1 in Java.
    // We must fix this.
    val zoneX = (x.toFloat / zoneDiameter).floor.toInt
    val zoneY = (y.toFloat / zoneDiameter).floor.toInt
    val coords = Coords(zoneX, zoneY)
    
    val zone = zones.get(coords) match {
        case Some(zone) => zone
        case None => {
            val zone = new Zone(zoneX, zoneY, zoneDiameter)
            zones(zone.coords) = zone
            zone
        }
    }

    // Calculate coordinate in zone. Ensure that in-zone coordinate is
    // calculated correctly if absolute coord is negative.
    def calcCoord(c: Int) = {
      if (c >= 0) c % zoneDiameter
      else {
        val mod = c.abs % zoneDiameter
        if (mod == 0) 0 else zoneDiameter - mod
      }
    }
    val ssX = calcCoord(x)
    val ssY = calcCoord(y)
    zone.markAsTaken(Coords(ssX, ssY))
  }

  /**
   * Quarters for random zone finder.
   */
  private val Quarters = Coords(1, 1) :: Coords(1, -1) :: Coords(-1, 1) ::
    Coords(-1, -1) :: Nil

  /**
   * Find random zone trying to start from galaxy center.
   */
  private def randomZone(): Zone = {
    var zoneAdded = false

    val zone = new Zone(0, 0, zoneDiameter)
    var slot = 1
    while (true) {
      // Shamelessly stolen from Mykolas, I don't really have much idea on what
      // is going on here.
      Quarters.foreach { quarter =>
        // find logical corrdinates in the first quarter
        val diag = ((math.sqrt(1 + 8 * slot) - 1) / 2).ceil
        val x = (diag / 2 * (1 + diag) - slot).toInt
        val y = (x - diag).toInt

        // transform logical coordinates to the quarter we need
        // taking into account the fact that we actually must calculate
        // coordinates of top-left corner in the
        // next step (-1 for x and -1 for y)
        zone.x = if (quarter.x == -1) -x - 1 else x
        zone.y = if (quarter.y == -1) -y - 1 else y

        // Check if we have zone in these coords
        zones.get(zone.coords) match {
          // If we do find existing zone
          case Some(existing) => {
              // Add if there are room for one more player there
              if (existing.playerCount < Config.playersPerZone) {
                return existing
              }
          }
          case None => return zone
        }
      }
      
      slot += 1
    }

    throw new IllegalStateException("There is no way we could get here!")
  }

  /**
   * Creates zone for player and returns homeworld id.
   */
  def createZoneFor(player: Player) = {    
    val zone = randomZone()
    zones(zone.coords) = zone
    /**
     * Only add additional solar systems if it is first player in that zone.
     */
    if (zone.playerCount == 0) {
      expansionSystems.times { () => zone.addSolarSystem(new Expansion()) }
      resourceSystems.times { () => zone.addSolarSystem(new Resource()) }
      wormholes.times { () => zone.addSolarSystem(new Wormhole()) }
    }

    zone.addSolarSystem(new Homeworld(player))
  }
}