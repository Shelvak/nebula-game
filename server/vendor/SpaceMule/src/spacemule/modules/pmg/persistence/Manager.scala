package spacemule.modules.pmg.persistence

import collection.mutable.{ListBuffer}
import java.util.Date
import objects._
import spacemule.modules.pmg.objects.{Location, Galaxy, Zone, SolarSystem, SSObject}
import scala.collection.mutable.HashSet
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.ss_objects.Planet
import spacemule.modules.pmg.objects.solar_systems.Battleground
import spacemule.modules.pmg.objects.solar_systems.Homeworld
import spacemule.modules.pmg.objects.solar_systems.Homeworld
import spacemule.modules.pmg.objects.ss_objects
import spacemule.persistence.DB

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 17, 2010
 * Time: 3:39:04 PM
 * To change this template use File | Settings | File Templates.
 */

object Manager {
  val galaxies = ListBuffer[String]()
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

  val galaxiesTable = "galaxies"
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
      "SELECT `id`, `x`, `y` FROM `%s` WHERE `galaxy_id`=%d".format(
        solarSystemsTable, galaxy.id
      )
    )

    while (rs.next) {
      val id = rs.getInt(1)
      val x = rs.getInt(2)
      val y = rs.getInt(3)

      galaxy.addExistingSS(x, y)
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

  private val saveTempHolders = updatedPlayerIds :: updatedAllianceIds :: Nil

  def save(beforeSave: Option[() => Unit]) = {
    TableIds.initialize()
    clearBuffers()
    saveTempHolders.foreach { set => set.clear }
    currentDateTime = DB.date(new Date())

    // Run something before save if provided
    beforeSave match {
      case Some(block) => block()
      case None => ()
    }

    // For debugging
    saveBuffers()
    // For production
    //speedup { () => saveBuffers() }
  }

  def save(beforeSave: () => Unit): Unit = save(Some(beforeSave))
  def save(): Unit = save(None)

  def save(galaxy: Galaxy): SaveResult = {
    save { () => readGalaxy(galaxy) }
    return SaveResult(updatedPlayerIds.toSet, updatedAllianceIds.toSet)
  }

  /**
   * Clears all buffers.
   */
  private def clearBuffers() = {
    List(galaxies, solarSystems, ssObjects, units, buildings,
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
//    val playerIds = players.map { p => p.split("\t")(0) }
//    val ssIds = solarSystems.map { p => p.split("\t")(0) }
//    val ssoSSids = ssObjects.map { p => p.split("\t")(2) }
//    val ssoPids = ssObjects.map { p => p.split("\t")(8) }
//
//    println("U PIDS:" + (ssoPids.toSet - DB.loadInFileNull -- playerIds.toSet))
//    println("U SSIDS:" + (ssoSSids.toSet -- ssIds.toSet))

    saveBuffer(galaxiesTable, GalaxyRow.columns, galaxies)
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
                         items: Seq[String]): Unit = {
    if (items.size == 0) return ()

//    println("************ %s **************".format(tableName))
//    println(columns)
//    items.foreach { i => println(i) }

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
    galaxy.zones.foreach { case (coords, zone) => readZone(galaxy, zone) }
  }

  private def readZone(galaxy: Galaxy, zone: Zone): Unit = {
    // Don't read zones without a defined player.
    if (! zone.hasNewPlayers) return ()

    zone.solarSystems.foreach { 
      case (coords, solarSystem) => {
          solarSystem match {
            case Some(ss) => {
              val absoluteCoords = zone.absolute(coords)
              readSolarSystem(galaxy, absoluteCoords, ss)
            }
            case None => ()
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

  def readBattleground(battleground: Battleground) = {
    val ssRow = new SolarSystemRow(battleground.galaxyId, battleground, None)
    solarSystems += ssRow.values

    readSSObjects(ssRow, battleground)

    ssRow
  }

  private def readSolarSystem(galaxy: Galaxy, coords: Coords,
                              solarSystem: SolarSystem) = {
    val ssRow = new SolarSystemRow(galaxy, solarSystem, coords)
    solarSystems += ssRow.values

    // Add visiblity for other players
    solarSystem match {
      case h: Homeworld => addSsVisibilityForExistingPlayers(ssRow, false, 
                                                             galaxy, coords)
      case _ => addSsVisibilityForExistingPlayers(ssRow, true, galaxy, coords)
    }

    readSSObjects(ssRow, solarSystem)

    ssRow
  }

  private def readSSObjects(ssRow: SolarSystemRow, solarSystem: SolarSystem) = {
    solarSystem.objects.foreach {
      case(coords, obj) => {
          val ssoRow = readSSObject(ssRow, coords, obj)

          // Add visibility, player and start quests for that player
          // if this is a homeworld.
          if (obj.isInstanceOf[ss_objects.Homeworld]) {
            val playerRow = ssoRow.playerRow.get
            fowSsEntries += FowSsEntryRow(ssRow, Some(playerRow.id), None, 1,
                                          false).values
            players += playerRow.values
            startQuests(playerRow)
          }
      }
    }
  }

  private def readSSObject(ssRow: SolarSystemRow, coords: Coords,
                           obj: SSObject) = {
    val ssoRow = new SSObjectRow(ssRow, coords, obj)

    ssObjects += ssoRow.values

    // Create units in orbit
    obj.units.foreach { unit =>
      val unitRow = new UnitRow(
        ssRow.galaxyId,
        Location(ssRow.id, Location.SolarSystemKind,
                 Some[Int](coords.x), Some[Int](coords.y)),
        unit
      )
      units += unitRow.values
    }

    // Additional creation steps
    obj match {
      case planet: Planet => readPlanet(ssRow.galaxyId, ssoRow, planet)
      case _ => ()
    }
    
    ssoRow
  }

  private def readPlanet(galaxyId: Int, ssoRow: SSObjectRow,
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
          galaxyId,
          Location(buildingRow.id, Location.BuildingKind, None, None),
          unit
        )
        units += unitRow.values
      }
    }
  }
}