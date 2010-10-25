package spacemule.modules.pmg.persistence

import collection.mutable.{ListBuffer}
import objects._
import spacemule.modules.pmg.objects.{Location, Galaxy, Zone, SolarSystem, SSObject}
import scala.collection.mutable.HashSet
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.ss_objects.{Asteroid, Planet}
import spacemule.persistence.DB

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 17, 2010
 * Time: 3:39:04 PM
 * To change this template use File | Settings | File Templates.
 */

object Manager {
  val solarSystems = ListBuffer[String]()
  val ssObjects = ListBuffer[String]()
  val resourcesEntries = ListBuffer[String]()
  val units = ListBuffer[String]()
  val buildings = ListBuffer[String]()
  val folliages = ListBuffer[String]()
  val tiles = ListBuffer[String]()
  val players = ListBuffer[String]()
  val fowSsEntries = ListBuffer[String]()

  val solarSystemsTable = "solar_systems"
  val ssObjectsTable = "planets"
  val resourceEntriesTable = "resources_entries"
  val tilesTable = "tiles"
  val folliagesTable = "folliages"
  val buildingsTable = "buildings"
  val unitsTable = "units"
  val playersTable = "players"
  val fowSsEntriesTable = "fow_ss_entries"
  val fowGalaxyEntriesTable = "fow_galaxy_entries"

  /**
   * Fow updates shoould be dispatched for these players.
   */
  private val updatedPlayerIds = HashSet[Int]()
  /**
   * Fow updates shoould be dispatched for these alliances.
   */
  private val updatedAllianceIds = HashSet[Int]()

  /**
   * Load current solar systems to avoid clashes.
   */
  def load(galaxy: Galaxy) = {
    val rs = DB.query(
      "SELECT `x`, `y` FROM `%s` WHERE `galaxy_id`=%d".format(
        solarSystemsTable, galaxy.id
      )
    )

    while (rs.next) {
      val x = rs.getInt(1)
      val y = rs.getInt(2)

      galaxy.addSolarSystem(x, y)
    }
  }

  def save(galaxy: Galaxy): SaveResult = {
    TableIds.initialize()
    clearBuffers()
    List(updatedPlayerIds, updatedAllianceIds).foreach { set => set.clear }

    readGalaxy(galaxy)
    // For debugging
    // saveBuffers()
    // For production
    speedup { () => saveBuffers() }

    return SaveResult(updatedPlayerIds, updatedAllianceIds)
  }

  /**
   * Clears all buffers.
   */
  private def clearBuffers() = {
    List(solarSystems, ssObjects, resourcesEntries, units, buildings,
         folliages, tiles, players, fowSsEntries
    ).foreach { buffer => buffer.clear }
  }

  private def speedup(block: () => Unit) = {
    DB.exec("SET UNIQUE_CHECKS=0")
    DB.exec("SET FOREIGN_KEY_CHECKS=0")
    DB.exec("BEGIN")
    block()
    DB.exec("COMMIT")
    DB.exec("SET UNIQUE_CHECKS=1")
    DB.exec("SET FOREIGN_KEY_CHECKS=1")
  }

  private def saveBuffers() = {
    saveBuffer(playersTable, PlayerRow.columns, players)
    saveBuffer(solarSystemsTable, SolarSystemRow.columns, solarSystems)
    saveBuffer(ssObjectsTable, SSObjectRow.columns, ssObjects)
    saveBuffer(resourceEntriesTable, ResourceEntryRow.columns,
               resourcesEntries)
    saveBuffer(tilesTable, TileRow.columns, tiles)
    saveBuffer(folliagesTable, TileRow.columns, folliages)
    saveBuffer(buildingsTable, BuildingRow.columns, buildings)
    saveBuffer(unitsTable, UnitRow.columns, units)
    saveBuffer(fowSsEntriesTable, FowSsEntryRow.columns, fowSsEntries)
  }

  private def saveBuffer(tableName: String, columns: String,
                         items: ListBuffer[String]) = {
    try {
      DB.loadInFile(tableName, columns, items)
    }
    catch {
      case ex: Exception => {
          System.err.println("Error while insert into `%s`".format(tableName))
          throw ex;
      }
    }
  }

  private def readGalaxy(galaxy: Galaxy) = {
    galaxy.zones.foreach { zone => readZone(galaxy, zone) }
  }

  private def readZone(galaxy: Galaxy, zone: Zone) = {
    val player = if (zone.player.isDefined) {
      zone.player.get
    }
    else error(
      "Cannot read zone if it has no player for %s".format(zone.toString)
    )

    val playerRow = PlayerRow(galaxy, player)
    players += playerRow.values

    zone.solarSystems.foreach { 
      case (coords, solarSystem) => {
          val absoluteCoords = zone.absolute(coords)
          val ssRow = readSolarSystem(galaxy, absoluteCoords, solarSystem,
            playerRow)
          addSsVisibilityForExistingPlayers(ssRow, galaxy, absoluteCoords)
          fowSsEntries += FowSsEntryRow(ssRow, playerRow, 1).values
      }
    }
  }

  private def addSsVisibilityForExistingPlayers(ssRow: SolarSystemRow,
                                                galaxy: Galaxy,
                                                coords: Coords) = {
    val rs = DB.query(
      """SELECT counter, player_id, alliance_id
        FROM fow_galaxy_entries WHERE galaxy_id=%d AND
        %d BETWEEN x AND x_end AND %d BETWEEN y AND y_end""".format(
        galaxy.id, coords.x, coords.y
      )
    )

    while (rs.next) {
      val (counter, playerId, allianceId) = (
        rs.getInt(1), rs.getInt(2), rs.getInt(3)
      )
      // If this is alliance row, player id will be 0
      // If this is player row, player id will be greater than 0
      val fowSseRow = if (playerId != 0) {
        updatedPlayerIds += playerId
        FowSsEntryRow(ssRow, Some(playerId), None, counter, true)
      }
      else {
        updatedAllianceIds += allianceId
        FowSsEntryRow(ssRow, None, Some(allianceId), counter, true)
      }
      fowSsEntries += fowSseRow.values
    }
  }

  private def readSolarSystem(galaxy: Galaxy, coords: Coords,
                              solarSystem: SolarSystem,
                              playerRow: PlayerRow) = {
    val ssRow = SolarSystemRow(galaxy, coords, solarSystem)
    solarSystems += ssRow.values

    solarSystem.objects.foreach {
      case(coords, obj) => readSSObject(galaxy, ssRow, coords, obj, playerRow)
    }

    ssRow
  }

  private def readSSObject(galaxy: Galaxy, ssRow: SolarSystemRow,
                           coords: Coords, obj: SSObject,
                           playerRow: PlayerRow) = {
    val ssoRow = new SSObjectRow(ssRow, coords, obj, playerRow)
    ssObjects += ssoRow.values

    // Create units in orbit
    obj.units.foreach { unit =>
      val unitRow = new UnitRow(
        galaxy,
        Location(ssRow.id, Location.SolarSystemKind,
                 Some[Int](coords.x), Some[Int](coords.y)),
        unit
      )
      units += unitRow.values
    }

    // Additional creation steps
    obj match {
      case asteroid: Asteroid => readResources(ssoRow, asteroid)
      case planet: Planet => readPlanet(galaxy, ssoRow, planet)
      case _ => None
    }
  }

  private def readResources(ssoRow: SSObjectRow, obj: SSObject) = {
    resourcesEntries += ResourceEntryRow(ssoRow, obj).values
  }

  private def readPlanet(galaxy: Galaxy, ssoRow: SSObjectRow,
                         planet: Planet) = {
    readResources(ssoRow, planet)

    planet.foreachTile { case (coord, kind) =>
        // Only add tiles which mean something.
        if (kind != Planet.TileNormal && kind != Planet.TileVoid) {
          val tileRow = new TileRow(ssoRow, kind, coord.x, coord.y)
          tiles += tileRow.values
        }
    }

    planet.foreachFolliage { case (coord, kind) =>
        val folliageRow = new TileRow(ssoRow, kind, coord.x, coord.y)
        folliages += folliageRow.values
    }

    planet.foreachBuilding { building =>
      val buildingRow = new BuildingRow(ssoRow, building)
      buildings += buildingRow.values

      building.units.foreach { unit =>
        val unitRow = new UnitRow(
          galaxy,
          Location(buildingRow.id, Location.BuildingKind,
                   Some[Int](building.x), Some[Int](building.y)),
          unit
        )
        units += unitRow.values
      }
    }
  }
}