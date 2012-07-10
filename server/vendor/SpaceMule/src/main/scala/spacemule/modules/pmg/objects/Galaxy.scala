package spacemule.modules.pmg.objects

import solar_systems.{Battleground, Homeworld, Pulsar, Wormhole}
import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.logging.Log
import collection.mutable.{ListBuffer, HashMap}
import spacemule.modules.pmg.persistence.Manager
import runtime.NonLocalReturnControl

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

  private[this] var _battleground: Option[Battleground] = None
  def battleground = _battleground

  private[this] var pooledHomeSystemCount = 0
  val pooledHomeSystems = ListBuffer.empty[Homeworld]

  // Add existing, attached solar system to zone list.
  def addExistingSS(
    x: Int, y: Int,
    playerId: Int, // 0 if NULL.
    age: Int
  ) {
    Log.block(
      "Adding existing SS @ "+x+","+y+" player_id:"+playerId+" age:"+age,
      level=Log.Debug
    ) { () =>
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
      Log.debug("Putting into zone: "+zone)

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

  def addPooledHomeSystems(count: Int) { pooledHomeSystemCount += count }

  /**
   * Adds zone to galaxy and creates non-player solar systems if it is empty.
   */
  private[this] def addZone(zone: Zone) {
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

  def createBattleground() {
    val battleground = new Battleground()
    battleground.createObjects()
    _battleground = Some(battleground)
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
   * @return number of zones created
   */
  def ensureFreeZones(count: Int, maxIterations: Option[Int]=None): Int = {
    val free = this.freeZones
    val toCreate = count - free
    if (toCreate <= 0) {
      Log.info(free + " zones are free, no new zones needed to create.")
      return 0
    }

    Log.block(
      "Ensuring that at least "+count+" zones are free, still need "+
      toCreate+" zones."
    ) { () =>
      var created = 0

      Zone.iterate(zoneDiameter, Config.zoneStartSlot) { zone =>
        // Exit if we created enough zones.
        if (created == toCreate) return created
        else // Still need new zones.
          if (zones.contains(zone.coords)) None // This zone is already created.
          else {
            addZone(zone)
            created += 1
            Log.debug("Created zone no. "+created+"/"+toCreate)
            // Keep iterating unless we have maxIterations specified and we've
            // hit the limit.
            maxIterations.map { max =>
              if (created != toCreate && created == max) {
                Log.info(
                  "Created "+created+" zones, still "+
                  (toCreate-created)+" to go, but exiting because "+
                  "maxIterations="+max+" has been hit."
                )
                return created
              }
            }
          }
      }
    }

    throw new IllegalStateException("Never should have arrived here.")
  }

  // Number of free zones in this galaxy.
  def freeHomeSystems = pooledHomeSystemCount

  def ensureFreeHomeSystems(
    count: Int, maxIterations: Option[Int]=None
  ): Int = {
    val toCreate = count - freeHomeSystems
    if (toCreate <= 0) {
      Log.info(
        freeHomeSystems + " home ss are free, no new home ss needed to create."
      )
      return 0
    }

    Log.block(
      "Ensuring that at least "+count+" home ss are free, still need "+
      toCreate+" home ss."
    ) { () =>
      var created = 0

      while (created < toCreate) {
        val ss = new Homeworld()
        ss.createObjects()
        pooledHomeSystems += ss
        created += 1
        Log.debug("Created home ss no. "+created+"/"+toCreate)

        maxIterations match {
          case None => ()
          case Some(iterations) =>
            if (created != toCreate && created == iterations) {
              Log.info(
                "Created "+created+" home ss, still "+
                (toCreate-created)+" to go, but exiting because "+
                "maxIterations="+iterations+" has been hit."
              )
              return created
            }
        }
      }

      created
    }
  }
}