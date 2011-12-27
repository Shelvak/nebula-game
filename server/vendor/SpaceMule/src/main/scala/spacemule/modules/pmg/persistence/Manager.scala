package spacemule.modules.pmg.persistence

import collection.mutable.ListBuffer
import objects._
import scala.collection.mutable.HashSet
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.ss_objects.Planet
import spacemule.persistence.DB
import java.util.{Calendar, Date}
import spacemule.modules.pmg.objects._
import solar_systems.{SpaceStation, Wormhole, Battleground, Homeworld}

object Manager {
  val galaxies = ListBuffer[String]()
  val solarSystems = ListBuffer[String]()
  val ssObjects = ListBuffer[String]()
  val units = ListBuffer[String]()
  val buildings = ListBuffer[String]()
  val foliages = ListBuffer[String]()
  val tiles = ListBuffer[String]()
  val players = ListBuffer[String]()
  val fowSsEntries = ListBuffer[String]()
  val questProgresses = ListBuffer[String]()
  val objectiveProgresses = ListBuffer[String]()
  val wreckages = ListBuffer[String]()
  val callbacks = ListBuffer[String]()

  val galaxiesTable = "galaxies"
  val solarSystemsTable = "solar_systems"
  val ssObjectsTable = "ss_objects"
  val tilesTable = "tiles"
  val foliagesTable = "folliages"
  val buildingsTable = "buildings"
  val unitsTable = "units"
  val playersTable = "players"
  val fowSsEntriesTable = "fow_ss_entries"
  val fowGalaxyEntriesTable = "fow_galaxy_entries"
  val questsTable = "quests"
  val questProgressesTable = "quest_progresses"
  val objectivesTable = "objectives"
  val objectiveProgressesTable = "objective_progresses"
  val wreckagesTable = "wreckages"
  val callbacksTable = "callbacks"

  /**
   * Current date to use in fields where NOW() is required.
   */
  var currentDateTime = "0000-00-00 00:00:00"

  /**
   * Created player rows.
   */
  private val playerRows = HashSet[PlayerRow]()
  /**
   * Fow updates should be dispatched for these players.
   */
  private val updatedPlayerIds = HashSet[Int]()
  /**
   * Fow updates should be dispatched for these alliances.
   */
  private val updatedAllianceIds = HashSet[Int]()

  /**
   * Quest ids that need to be started when creating player.
   */
  private var startQuestIds = loadQuests()

  /**
   * Objective ids that need to be started when creating player.
   */
  private var startObjectiveIds = loadObjectives()

  /**
   * Load current solar systems to avoid clashes.
   */
  def load(galaxy: Galaxy) {
    loadSolarSystems(galaxy)
  }

  private def loadSolarSystems(galaxy: Galaxy) {
    val rs = DB.query(
      "SELECT `x`, `y` FROM `%s` WHERE `galaxy_id`=%d".format(
        solarSystemsTable, galaxy.id
      )
    )

    while (rs.next) {
      val x = rs.getInt(1)
      val y = rs.getInt(2)

      galaxy.addExistingSS(x, y)
    }
  }

  private def loadQuests(): Seq[Int] = {
    DB.getCol[Int](
      "SELECT `id` FROM `%s` WHERE `parent_id` IS NULL".format(questsTable)
    )
  }

  private def loadObjectives(): Seq[Int] = {
    if (startQuestIds.isEmpty) Seq[Int]()
    else DB.getCol[Int](
      "SELECT `id` FROM `%s` WHERE `quest_id` IN (%s)".format(
        objectivesTable, startQuestIds.mkString(",")
      )
    )
  }

  private val saveTempHolders = updatedPlayerIds :: updatedAllianceIds ::
    playerRows :: Nil

  def save(beforeSave: Option[() => Unit]) {
    TableIds.initialize()
    clearBuffers()
    saveTempHolders.foreach { set => set.clear() }
    currentDateTime = DB.date(new Date())
    
    // Reload quest/objective ids because they might have changed. E.g. when
    // testing.
    if (System.getenv("environment") != "production") {
      startQuestIds = loadQuests()
      startObjectiveIds = loadObjectives()
    }

    // Run something before save if provided
    beforeSave match {
      case Some(block) => block()
      case None => ()
    }

    if (System.getenv("environment") == "production")
      speedup { () => saveBuffers() }
    else
      saveBuffers()
  }

  def save(beforeSave: () => Unit) { save(Some(beforeSave)) }
  def save() { save(None) }

  def save(galaxy: Galaxy): SaveResult = {
    save { () => readGalaxy(galaxy) }
    SaveResult(
      playerRows.toSet,
      updatedPlayerIds.toSet,
      updatedAllianceIds.toSet
    )
  }

  /**
   * Clears all buffers.
   */
  private def clearBuffers() {
    List(
      galaxies, solarSystems, ssObjects, units, buildings,
      foliages, tiles, players, fowSsEntries, questProgresses,
      objectiveProgresses, wreckages
    ).foreach(_.clear())
  }

  private def speedup(block: () => Unit) {
    DB.exec("SET UNIQUE_CHECKS=0")
    DB.exec("SET FOREIGN_KEY_CHECKS=0")
    DB.exec("BEGIN")
    block()
    DB.exec("COMMIT")
    DB.exec("SET UNIQUE_CHECKS=1")
    DB.exec("SET FOREIGN_KEY_CHECKS=1")
  }

// Only for debugging.
//  private def checkFks(
//    childCols: String, childKey: String, childRows: Seq[String],
//    parentCols: String, parentKey: String, parentRows: Seq[String]
//  ) = {
//    def keyIndex(cols: String, key: String) = cols.split(",").indexWhere {
//      item => item.replace("`", "").trim == key
//    }
//    def mapToValue(row: String, index: Int) = row.split("\t")(index)
//    def mapToValues(rows: Seq[String], index: Int) = rows.map { row =>
//       mapToValue(row, index) }
//
//    val childKeyIndex = keyIndex(childCols, childKey)
//    val parentKeyIndex = keyIndex(parentCols, parentKey)
//    val parentValues = mapToValues(parentRows, parentKeyIndex)
//
//    childRows.foreach { row =>
//      val fkValue = mapToValue(row, childKeyIndex)
//      if (! (fkValue == DB.loadInFileNull || parentValues.contains(fkValue))) {
//        System.err.println("Parent data:")
//        System.err.println(parentCols)
//        parentRows.foreach { System.err.println(_) }
//        System.err.println()
//        System.err.println("Child data:")
//        System.err.println(childCols)
//        System.err.println(row)
//        System.err.println()
//        System.exit(-1)
//      }
//    }
//  }
//
//  private def dumpTable(tableName: String, columns: String,
//                        items: Seq[String]) = {
//    println("************ %s **************".format(tableName))
//    println(columns)
//    items.foreach { i => println(i) }
//  }

  private def saveBuffers() {
//    checkFks(SSObjectRow.columns, "solar_system_id", ssObjects,
//             SolarSystemRow.columns, "id", solarSystems)
//    checkFks(SSObjectRow.columns, "player_id", ssObjects,
//             PlayerRow.columns, "id", players)

//    dumpTable(solarSystemsTable, SolarSystemRow.columns, solarSystems)

    saveBuffer(galaxiesTable, GalaxyRow.columns, galaxies)
    saveBuffer(callbacksTable, CallbackRow.columns, callbacks)
    saveBuffer(playersTable, PlayerRow.columns, players)
    saveBuffer(solarSystemsTable, SolarSystemRow.columns, solarSystems)
    saveBuffer(ssObjectsTable, SSObjectRow.columns, ssObjects)
    saveBuffer(tilesTable, TileRow.columns, tiles)
    saveBuffer(foliagesTable, TileRow.columns, foliages)
    saveBuffer(buildingsTable, BuildingRow.columns, buildings)
    saveBuffer(unitsTable, UnitRow.columns, units)
    saveBuffer(fowSsEntriesTable, FowSsEntryRow.columns, fowSsEntries)
    saveBuffer(questProgressesTable, QuestProgressRow.columns,
               questProgresses)
    saveBuffer(objectiveProgressesTable, ObjectiveProgressRow.columns,
               objectiveProgresses)
    saveBuffer(wreckagesTable, WreckageRow.columns, wreckages)
  }

  private def saveBuffer(tableName: String, columns: String,
                         items: Seq[String]) {
    if (items.size == 0) return

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

  private def readGalaxy(galaxy: Galaxy) {
    CallbackRow.initPlayerInactivityCheck
    CallbackRow.initAsteroidSpawn
    CallbackRow.initSsUnitsSpawn
    galaxy.zones.foreach { case (coords, zone) => readZone(galaxy, zone) }
  }

  private def readZone(galaxy: Galaxy, zone: Zone) {
    // Don't read zones without any defined players.
    if (! zone.hasNewPlayers) return

    zone.solarSystems.foreach { 
      case (coords, solarSystem) => {
          solarSystem match {
            case Some(ss) => {
              val absoluteCoords = zone.absolute(coords)
              readSolarSystem(galaxy, Some(absoluteCoords), ss)
            }
            case None => ()
          }
      }
    }
  }

  private def startQuests(playerRow: PlayerRow) {
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
                                                coords: Coords) {
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

  private var playerRowsCache = Map.empty[Player, PlayerRow]

  private def getPlayerRow(player: Player, galaxyId: Int) = {
    playerRowsCache.get(player) match {
      case Some(playerRow) => playerRow
      case None =>
        val playerRow = new PlayerRow(galaxyId, player)
        playerRowsCache += player -> playerRow
        playerRow
    }
  }
  
  def readSolarSystem(
    galaxy: Galaxy, coords: Option[Coords], solarSystem: SolarSystem
  ) = {
    val playerRow = solarSystem match {
      case hw: Homeworld => Some(getPlayerRow(hw.player, galaxy.id))
      case ss: SpaceStation => Some(getPlayerRow(ss.player, galaxy.id))
      case _ => None
    }

    val ssRow = new SolarSystemRow(galaxy.id, solarSystem, coords, playerRow)
    solarSystems += ssRow.values

    // Create solar system units
    solarSystem.units.foreach { case (ssPointCoord, troops) =>
      val location = Location(
        ssRow.id, Location.SolarSystem,
        Some(ssPointCoord.x), Some(ssPointCoord.y)
      )
      troops.foreach { troop =>
        val unitRow = new UnitRow(ssRow.galaxyId, location, troop)
        units += unitRow.values
      }
    }

    // Create wreckages
    solarSystem.wreckages.foreach { case(ssPointCoord, wreckage) =>
      val location = Location(
        ssRow.id, Location.SolarSystem,
        Some(ssPointCoord.x), Some(ssPointCoord.y)
      )
      val wreckageRow = WreckageRow(ssRow.galaxyId, location, wreckage)
      wreckages += wreckageRow.values
    }

    def addSpawn() = {
      callbacks += CallbackRow(
        ssRow, galaxy.ruleset,
        CallbackRow.Events.Spawn, Calendar.getInstance
      ).values
    }

    // Add visibility for other players & spawns.
    solarSystem match {
      case _: Homeworld =>
        addSsVisibilityForExistingPlayers(ssRow, false, galaxy, coords.get)

        // Add visibility, player and start quests for that player
        // if this is a homeworld.
        fowSsEntries += FowSsEntryRow(ssRow, Some(playerRow.get.id), None, 1,
          false).values
        playerRows += playerRow.get
        players += playerRow.get.values
        startQuests(playerRow.get)

        // Add player inactivity check
        callbacks += CallbackRow(
          playerRow.get, galaxy.ruleset,
          CallbackRow.Events.CheckInactivePlayer,
          CallbackRow.playerInactivityCheck
        ).values
        addSpawn() // Spawn callback
      case _: SpaceStation =>
        addSsVisibilityForExistingPlayers(ssRow, true, galaxy, coords.get)
      case _: Wormhole =>
        addSsVisibilityForExistingPlayers(ssRow, true, galaxy, coords.get)
      case _: Battleground =>
        addSpawn() // Spawn callback
      case _ =>
        addSsVisibilityForExistingPlayers(ssRow, true, galaxy, coords.get)
        addSpawn() // Spawn callback
    }

    readSSObjects(galaxy, ssRow, solarSystem)

    ssRow
  }

  private def readSSObjects(galaxy: Galaxy, ssRow: SolarSystemRow,
                            solarSystem: SolarSystem) {
    solarSystem.objects.foreach {
      case(coords, obj) =>
        readSSObject(galaxy, ssRow, coords, obj)
    }
  }

  private def readSSObject(galaxy: Galaxy, ssRow: SolarSystemRow,
                           coords: Coords, obj: SSObject) {
    val ssoRow = SSObjectRow(ssRow, coords, obj)
    ssObjects += ssoRow.values

    // Create units in ground
    obj.units.foreach { unit =>
      val unitRow = new UnitRow(
        ssRow.galaxyId,
        Location(ssoRow.id, Location.SsObject, None, None),
        unit
      )
      units += unitRow.values
    }

    // Additional creation steps
    obj match {
      case planet: ss_objects.Planet =>
        readPlanet(galaxy, ssRow.galaxyId, ssoRow, planet)
      case asteroid: ss_objects.Asteroid =>
        readAsteroid(galaxy, ssoRow)
      case _ => ()
    }
  }

  private def readAsteroid(galaxy: Galaxy, ssoRow: SSObjectRow) = {
    callbacks += CallbackRow(
      ssoRow, galaxy.ruleset,
      CallbackRow.Events.Spawn,
      CallbackRow.asteroidSpawn
    ).values
  }

  private def readPlanet(galaxy: Galaxy, galaxyId: Int, ssoRow: SSObjectRow,
                         planet: Planet) {
    callbacks += CallbackRow(
      ssoRow, galaxy.ruleset,
      CallbackRow.Events.Raid,
      planet.nextRaidAt
    ).values

    planet.foreachTile { case (coord, kind) =>
        // Only add tiles which mean something.
        if (kind != Planet.TileNormal && kind != Planet.TileVoid) {
          val tileRow = new TileRow(ssoRow, kind, coord.x, coord.y)
          tiles += tileRow.values
        }
    }

    planet.foreachFolliage { case (coord, kind) =>
        val folliageRow = new TileRow(ssoRow, kind, coord.x, coord.y)
        foliages += folliageRow.values
    }

    planet.foreachBuilding { building =>
      val buildingRow = new BuildingRow(ssoRow, building)
      buildings += buildingRow.values

      building.units.foreach { unit =>
        val unitRow = new UnitRow(
          galaxyId,
          Location(buildingRow.id, Location.Building, None, None),
          unit
        )
        units += unitRow.values
      }
    }
  }
}