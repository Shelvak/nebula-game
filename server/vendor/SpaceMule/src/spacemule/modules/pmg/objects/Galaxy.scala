package spacemule.modules.pmg.objects

import scala.collection.mutable.HashMap
import solar_systems.{Resource, Expansion, Homeworld}
import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.classes.geom.Coords
import util.Random

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
  val zones = new HashMap[Coords, Zone]()
  val shifts = IndexedSeq(-1, 0, 1)

  def addSolarSystem(x: Int, y: Int): Zone = {
    // For some reason -1 / 2 == 0 instead of -1 in Java.
    // We must fix this.
    val zoneX = (x.toFloat / zoneDiameter).floor.toInt
    val zoneY = (y.toFloat / zoneDiameter).floor.toInt
    val zone = new Zone(zoneX, zoneY, zoneDiameter)
    if (! zones.contains(zone.coords)) {
      zones(zone.coords) = zone
    }

    zone
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
    zone.registerPlayer(player)
    zones(zone.coords) = zone

    zone.addSolarSystem(new Homeworld(player))
    /**
     * Only add additional solar systems if it is first player in that zone.
     */
    if (zone.playerCount == 1) {
      (1 to expansionSystems).foreach { index =>
        zone.addSolarSystem(new Expansion())
      }
      (1 to resourceSystems).foreach { index =>
        zone.addSolarSystem(new Resource())
      }
    }
  }
}