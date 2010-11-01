package spacemule.modules.pmg.objects

import solar_systems.{Resource, Expansion, Homeworld}
import spacemule.helpers.Converters._
import collection.mutable.HashSet
import spacemule.modules.config.objects.Config
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
  val zones = new HashSet[Zone]()
  val shifts = IndexedSeq(-1, 0, 1)

  def addSolarSystem(x: Int, y: Int) = {
    // For some reason -1 / 2 == 0 instead of -1 in Java.
    // We must fix this.
    val zoneX = (x.toFloat / zoneDiameter).floor.toInt
    val zoneY = (y.toFloat / zoneDiameter).floor.toInt
    val zone = new Zone(zoneX, zoneY, zoneDiameter)
    if (! zones.contains(zone)) {
      zones += zone
    }
  }

  private def randomZone(xShift: Int, yShift: Int): Zone = {
    var zoneAdded = false

    val zone = new Zone(0, 0, zoneDiameter)
    while (! zoneAdded) {
      if (zones.contains(zone)) {
        zone.x += xShift
        zone.y += yShift
      }
      else {
        zoneAdded = true
      }
    }

    zone
  }

  /**
   * Creates zone for player and returns homeworld id.
   */
  def createZoneFor(player: Player) = {
    val xShift = shifts.random
    val yShift = if (xShift == 0) {
      1 * (if (Random.nextBoolean) 1 else -1)
    } else shifts.random
    
    val zone = randomZone(xShift, yShift)
    zone.player = Some(player)

    zone.addSolarSystem(new Homeworld())
    (1 to expansionSystems).foreach { index =>
      zone.addSolarSystem(new Expansion())
    }
    (1 to resourceSystems).foreach { index =>
      zone.addSolarSystem(new Resource())
    }
    zones += zone
  }
}