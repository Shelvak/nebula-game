package spacemule.modules.pmg.persistence

import collection.mutable.{ListBuffer}
import java.text.SimpleDateFormat
import java.util.Date
import objects._
import spacemule.modules.pmg.objects.{Location, Galaxy, Zone, SolarSystem, SSObject}
import scala.collection.mutable.HashSet
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.solar_systems.Homeworld
import spacemule.modules.pmg.objects.ss_objects.Planet
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
  val units = ListBuffer[String]()
  val buildings = ListBuffer[String]()
  val folliages = ListBuffer[String]()
  val tiles = ListBuffer[String]()
  val players = ListBuffer[String]()
  val fowSsEntries = ListBuffer[String]()
  val questProgresses = ListBuffer[String]()
  val objectiveProgresses = ListBuffer[String]()

  val solarSystemsTable = "solar_systems"
  val ssObjectsTable = "ss_objects"
  val tilesTable = "tiles"
  val folliagesTable = "folliages"
  val buildingsTable = "buildings"
  val unitsTable = "units"
  val playersTable = "players"
  val fowSsEntriesTable = "fow_ss_entries"
  val fowGalaxyEntriesTable = "fow_galaxy_entries"
  val questsTable = "quests"
  val questProgressesTable = "quest_progresses"
  val objectivesTable = "objectives"
  val objectiveProgressesTable = "objective_progresses"

  /**
   * Current date to use in fields where NOW() is required.
   */
  var currentDateTime = "0000-00-00 00:00:00"

  /**
   * Fow updates shoould be dispatched for these players.
   */
  private val updatedPlayerIds = HashSet[Int]()
  /**
   * Fow updates shoould be dispatched for these alliances.
   */
  private val updatedAllianceIds = HashSet[Int]()

  /**
   * Quest ids that need to be started when creating player.
   */
  private val startQuestIds = loadQuests()

  /**
   * Objective ids that need to be started when creating player.
   */
  private val startObjectiveIds = loadObjectives()

  /**
   * Load current solar systems to avoid clashes.
   */
  def load(galaxy: Galaxy) = {
    loadSolarSystems(galaxy)
  }

  private def loadSolarSystems(galaxy: Galaxy) = {
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

  private def loadQuests(): Seq[Int] = {
    return DB.getCol[Int](
      "SELECT `id` FROM `%s` WHERE `parent_id` IS NULL".format(
        questsTable
      )
    )
  }

  private def loadObjectives(): Seq[Int] = {
    return if (startQuestIds.isEmpty) Seq[Int]() else DB.getCol[Int](
      "SELECT `id` FROM `%s` WHERE `quest_id` IN (%s)".format(
        objectivesTable, startQuestIds.mkString(",")
      )
    )
  }

  def save(galaxy: Galaxy): SaveResult = {
    TableIds.initialize()
    clearBuffers()
    List(updatedPlayerIds, updatedAllianceIds).foreach { set => set.clear }
    currentDateTime = new SimpleDateFormat(
      "yyyy-MM-dd HH:mm:ss").format(new Date())

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
    List(solarSystems, ssObjects, units, buildings,
         folliages, tiles, players, fowSsEntries, questProgresses,
         objectiveProgresses
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
    saveBuffer(tilesTable, TileRow.columns, tiles)
    saveBuffer(folliagesTable, TileRow.columns, folliages)
    saveBuffer(buildingsTable, BuildingRow.columns, buildings)
    saveBuffer(unitsTable, UnitRow.columns, units)
    saveBuffer(fowSsEntriesTable, FowSsEntryRow.columns, fowSsEntries)
    saveBuffer(questProgressesTable, QuestProgressRow.columns,
               questProgresses)
    saveBuffer(objectiveProgressesTable, ObjectiveProgressRow.columns,
               objectiveProgresses)
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

  private def readZone(galaxy: Galaxy, zone: Zone): Unit = {
    // Don't read zones without a defined player.
    if (! zone.player.isDefined) {
      return ()
    }

    val player = zone.player.get
    val playerRow = PlayerRow(galaxy, player)
    players += playerRow.values

    startQuests(playerRow)

    zone.solarSystems.foreach { 
      case (coords, solarSystem) => {
          val absoluteCoords = zone.absolute(coords)
          val ssRow = readSolarSystem(galaxy, absoluteCoords, solarSystem,
            playerRow)
          if (solarSystem.isInstanceOf[Homeworld]) {
            fowSsEntries += FowSsEntryRow(
              ssRow, Some(playerRow.id), None, 1, false).values
            addSsVisibilityForExistingPlayers(ssRow, false, galaxy,
                                              absoluteCoords)
          }
          else {
            addSsVisibilityForExistingPlayers(ssRow, true, galaxy,
                                              absoluteCoords)
          }
      }
    }
  }

  private def startQuests(playerRow: PlayerRow) = {
    startQuestIds.foreach { questId =>
      questProgresses += QuestProgressRow(questId, playerRow.id).values
    }
    startObjectiveIds.foreach { objectiveId =>
      objectiveProgresses += ObjectiveProgressRow(
        objectiveId, playerRow.id).values
    }
  }

  private def addSsVisibilityForExistingPlayers(ssRow: SolarSystemRow,
                                                empty: Boolean,
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
        FowSsEntryRow(ssRow, Some(playerId), None, counter, empty, true)
      }
      else {
        updatedAllianceIds += allianceId
        FowSsEntryRow(ssRow, None, Some(allianceId), counter, empty, true)
      }
      fowSsEntries += fowSseRow.values
    }
  }

  private def readSolarSystem(galaxy: Galaxy, coords: Coords,
                              solarSystem: SolarSystem,
                              playerRow: PlayerRow) = {
    val ssRow = SolarSystemRow(galaxy, coords)
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
      case planet: Planet => readPlanet(galaxy, ssoRow, planet)
      case _ => ()
    }
  }

  private def readPlanet(galaxy: Galaxy, ssoRow: SSObjectRow,
                         planet: Planet) = {
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
          Location(buildingRow.id, Location.BuildingKind, None, None),
          unit
        )
        units += unitRow.values
      }
    }
  }
}