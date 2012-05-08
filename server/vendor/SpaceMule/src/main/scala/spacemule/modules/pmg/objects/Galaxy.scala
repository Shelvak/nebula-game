package spacemule.modules.pmg.objects

import scala.collection.mutable.HashMap
import solar_systems.{Homeworld, Pulsar, Wormhole}
import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.logging.Log

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
  private[this] var freeHomeSystemCount = 0

  def addExistingSS(
    coords: Option[Coords],
    playerId: Int, // 0 if NULL.
    age: Int
  ) {
    coords match {
      case None =>
        // This is a pooled home solar system.
        freeHomeSystemCount += 1
      case Some(c) =>
        // This is a regular, attached solar system.
        val x = c.x
        val y = c.y

        // For some reason -1 / 2 == 0 instead of -1 in Java.
        // We must fix this.
        val zoneX = (x.toFloat / zoneDiameter).floor.toInt
        val zoneY = (y.toFloat / zoneDiameter).floor.toInt
        val zoneCoords = Coords(zoneX, zoneY)

        val zone = zones.get(zoneCoords) match {
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
  }

  /**
   * Find random zone trying to start from galaxy center.
   */
  private def randomZone(): Zone = {
    Zone.iterate(zoneDiameter, Config.zoneStartSlot) { zone =>
      // Check if we have zone in these coords
      zones.get(zone.coords) match {
        // If we do find existing zone
        case Some(existing) =>
          // Add if there are room for one more player there
          if (existing.isFull) None
          else Some(existing)
        case None => Some(zone)
      }
    }
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
    Log.block("Creating zone " + zone, level=Log.Debug) { () =>
      zones(zone.coords) = zone

      def cStr(coords: Coords) = {
        val abs = zone.absolute(coords)
        "rel:"+coords.x+","+coords.y+" abs:"+abs.x+","+abs.y
      }

      wormholes.foreach { coords =>
        Log.block("Adding wormhole @ " + cStr(coords), level=Log.Debug) { () =>
          zone.addSolarSystem(new Wormhole(), coords, skipExisting = true)
        }
      }
      freeSystems.foreach { coords =>
        Log.block("Adding free ss @ " + cStr(coords), level=Log.Debug) { () =>
          zone.addSolarSystem(
            new SolarSystem(Config.freeSsConfig), coords, skipExisting = true
          )
        }
      }
      miniBattlegrounds.foreach { coords =>
        Log.block("Adding mini bg @ " + cStr(coords), level=Log.Debug) { () =>
          zone.addSolarSystem(new Pulsar(), coords, skipExisting = true)
        }
      }
    }
  }

  // Number of free zones in this galaxy.
  def freeZones =
    zones.foldLeft(0) { case (free, (coords, zone)) =>
      if (zone.isMature || zone.hasPlayers) free else free + 1
    }

  /**
   * Ensure that at least freeZones zones are free in this galaxy.
   *
   * If maxIterations is given, algorithm exists when it reaches iteration limit
   * even if there still are zones to create.
   *
   * This is useful to prevent huge inserts into mysql.
   *
   * @param count
   * @param maxIterations
   */
  def ensureFreeZones(count: Int, maxIterations: Option[Int]=None) {
    val toCreate = count - this.freeZones
    Log.block(
      "Ensuring that at least "+count+" zones are free, still need "+
      toCreate+" zones."
    ) { () =>
      var created = 0

      Zone.iterate(zoneDiameter, Config.zoneStartSlot) { zone =>
        // Exit if we created enough zones.
        if (created == toCreate) Some(zone)
        else // Still need new zones.
          if (zones.contains(zone.coords)) None // This zone is already created.
          else {
            addZone(zone)
            created += 1
            Log.debug("Created zone no. "+created+"/"+toCreate)
            // Keep iterating unless we have maxIterations specified and we've
            // hit the limit.
            maxIterations.map { max =>
              if (created == max) {
                Log.info(
                  "Created "+created+" zones, still "+
                  (toCreate-created)+" to go, but exiting because "+
                  "maxIterations has been hit."
                )
                Some(zone)
              }
              else None
            }
          }
      }
    }
  }

  // Number of free zones in this galaxy.
  def freeHomeSystems = freeHomeSystemCount

  def ensureFreeHomeSystems(count: Int, maxIterations: Option[Int]=None) {
    val toCreate = count - freeHomeSystems
    Log.block(
      "Ensuring that at least "+count+" home ss are free, still need "+
      toCreate+" home ss."
    ) { () =>
      var created = 0

      val ss = new Homeworld()

      Zone.iterate(zoneDiameter, Config.zoneStartSlot) { zone =>
        // Exit if we created enough zones.
        if (created == toCreate) Some(zone)
        else // Still need new zones.
          if (zones.contains(zone.coords)) None // This zone is already created.
          else {
            addZone(zone)
            created += 1
            Log.debug("Created zone no. "+created+"/"+toCreate)
            // Keep iterating unless we have maxIterations specified and we've
            // hit the limit.
            maxIterations.map { max =>
              if (created == max) {
                Log.info(
                  "Created "+created+" zones, still "+
                  (toCreate-created)+" to go, but exiting because "+
                  "maxIterations has been hit."
                )
                Some(zone)
              }
              else None
            }
          }
      }
    }
  }
}