package spacemule.modules.pmg.objects

import scala.collection.mutable.HashMap
import solar_systems.{Homeworld, Pulsar, Wormhole}
import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.classes.geom.Coords

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 11:36:16 AM
 * To change this template use File | Settings | File Templates.
 */

class Galaxy(val id: Int, val ruleset: String) {
  val zoneDiameter = Config.zoneDiameter
  val freeSystems = Config.freeSolarSystems
  val wormholes = Config.wormholes
  val miniBattlegrounds = Config.miniBattlegrounds
  val zones = new HashMap[Coords, Zone]()

  def addExistingSS(
    x: Int,
    y: Int,
    playerId: Int, // 0 if NULL.
    age: Int
  ) {
    // For some reason -1 / 2 == 0 instead of -1 in Java.
    // We must fix this.
    val zoneX = (x.toFloat / zoneDiameter).floor.toInt
    val zoneY = (y.toFloat / zoneDiameter).floor.toInt
    val coords = Coords(zoneX, zoneY)
    
    val zone = zones.get(coords) match {
      case Some(z) => z
      case None =>
        val zone = new Zone(zoneX, zoneY, zoneDiameter)
        zones(zone.coords) = zone
        zone
    }

    if (age >= Config.zoneMaturityAge) {
      zone.markAsMature()
    }
    else {
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
      zone.markAsTaken(Coords(ssX, ssY), playerId != 0)
    }
  }

  /**
   * Find random zone trying to start from galaxy center.
   */
  private def randomZone(): Zone = {
    val zone = new Zone(0, 0, zoneDiameter)
    var slot = Config.zoneStartSlot
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
        zone.x = if (quarter.x == -1) -x - 1 else x
        zone.y = if (quarter.y == -1) -y - 1 else y

        // Check if we have zone in these coords
        zones.get(zone.coords) match {
          // If we do find existing zone
          case Some(existing) =>
            // Add if there are room for one more player there
            if (! existing.isFull) {
              return existing
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
  def createZoneFor(player: Player) {
    val zone = randomZone()
    addZone(zone)

    zone.addSolarSystem(new Homeworld(player))
  }

  /**
   * Adds zone to galaxy and creates non-player solar systems if it is empty.
   */
  def addZone(zone: Zone) {
    zones(zone.coords) = zone

    wormholes.foreach { coords =>
      zone.addSolarSystem(new Wormhole(), coords, skipExisting = true)
    }
    freeSystems.foreach { coords =>
      zone.addSolarSystem(
        new SolarSystem(Config.freeSsConfig), coords, skipExisting = true
      )
    }
    miniBattlegrounds.foreach { coords =>
      zone.addSolarSystem(new Pulsar(), coords, skipExisting = true)
    }
  }
}