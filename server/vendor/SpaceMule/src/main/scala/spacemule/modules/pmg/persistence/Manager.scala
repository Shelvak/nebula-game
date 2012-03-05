package spacemule.modules.pmg.persistence

import manager.{Buffer, BufferManager}
import objects._
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.ss_objects.Planet
import spacemule.persistence.DB
import java.util.{Calendar, Date}
import spacemule.modules.pmg.objects._
import solar_systems.{Wormhole, Battleground, Homeworld}
import collection.mutable.{HashMap, ListBuffer, HashSet}

object Manager {
  val GalaxiesTable = "galaxies"
  val PlayersTable = "players"
  val SolarSystemsTable = "solar_systems"
  val SolarSystemObjectsTable = "ss_objects"
  val TilesTable = "tiles"
  val FoliagesTable = "folliages"
  val BuildingsTable = "buildings"
  val UnitsTable = "units"
  val FowSsEntriesTable = "fow_ss_entries"
  val FowGalaxyEntriesTable = "fow_galaxy_entries"
  val QuestsTable = "quests"
  val QuestProgressesTable = "quest_progresses"
  val ObjectivesTable = "objectives"
  val ObjectiveProgressesTable = "objective_progresses"
  val WreckagesTable = "wreckages"
  val CallbacksTable = "callbacks"

  private[this] val buffers = new BufferManager(
    new Buffer(GalaxiesTable, GalaxyRow),
    new Buffer(PlayersTable, PlayerRow),
    new Buffer(SolarSystemsTable, SolarSystemRow),
    new Buffer(SolarSystemObjectsTable, SSObjectRow),
    new Buffer(TilesTable, TileRow),
    new Buffer(FoliagesTable, TileRow),
    new Buffer(BuildingsTable, BuildingRow),
    new Buffer(UnitsTable, UnitRow),
    new Buffer(FowSsEntriesTable, FowSsEntryRow),
    new Buffer(QuestProgressesTable, QuestProgressRow),
    new Buffer(ObjectiveProgressesTable, ObjectiveProgressRow),
    new Buffer(WreckagesTable, WreckageRow),
    // Last because of FKs
    new Buffer(CallbacksTable, CallbackRow)
  )
  
  val galaxies = buffers.get(GalaxiesTable)
  val players = buffers.get(PlayersTable)
  val solarSystems = buffers.get(SolarSystemsTable)
  val ssObjects = buffers.get(SolarSystemObjectsTable)
  val tiles = buffers.get(TilesTable)
  val foliages = buffers.get(FoliagesTable)
  val buildings = buffers.get(BuildingsTable)
  val units = buffers.get(UnitsTable)
  val fowSsEntries = buffers.get(FowSsEntriesTable)
  val questProgresses = buffers.get(QuestProgressesTable)
  val objectiveProgresses = buffers.get(ObjectiveProgressesTable)
  val wreckages = buffers.get(WreckagesTable)
  val callbacks = buffers.get(CallbacksTable)

  /**
   * Current date to use in fields where NOW() is required.
   */
  var currentDateTime = "0000-00-00 00:00:00"

  /**
   * Created player rows.
   */
  private val playerRows = HashSet[PlayerRow]()
  /**
   * Fow ss entry rows that were created during this save.
   */
  private var fsesForExisting =
    HashMap.empty[SolarSystemRow, ListBuffer[FowSsEntryRow]]

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
    val now = DB.date(Calendar.getInstance())
    val rs = DB.query(
      """
SELECT
  ss.`x`,
  ss.`y`,
  ss.`player_id`,
  IF(p.`created_at`, TO_SECONDS('%s') - TO_SECONDS(p.`created_at`), 0) AS age
FROM
  `%s` AS ss
LEFT JOIN
  `%s` AS p
ON
  ss.`player_id`=p.`id`
WHERE
  ss.`galaxy_id`=%d
      """.format(now, SolarSystemsTable, PlayersTable, galaxy.id)
    )

    while (rs.next) {
      val x = rs.getInt(1)
      val y = rs.getInt(2)
      val playerId = rs.getInt(3)
      val age = rs.getInt(4)

      galaxy.addExistingSS(x, y, playerId, age)
    }
  }

  private def loadQuests(): Seq[Int] = {
    DB.getCol[Int](
      "SELECT `id` FROM `%s` WHERE `parent_id` IS NULL".format(QuestsTable)
    )
  }

  private def loadObjectives(): Seq[Int] = {
    if (startQuestIds.isEmpty) Seq[Int]()
    else DB.getCol[Int](
      "SELECT `id` FROM `%s` WHERE `quest_id` IN (%s)".format(
        ObjectivesTable, startQuestIds.mkString(",")
      )
    )
  }

  type Clearable = {def clear(): Unit}
  private val saveTempHolders = List[Clearable](fsesForExisting, playerRows)

  def save[T](beforeSave: () => T): T = {
    buffers.clear()
    saveTempHolders.foreach { set => set.clear() }
    currentDateTime = DB.date(new Date())
    
    // Reload quest/objective ids because they might have changed. E.g. when
    // testing.
    if (System.getenv("environment") != "production") {
      startQuestIds = loadQuests()
      startObjectiveIds = loadObjectives()
    }

    // Run something before save if provided
    val retVal = beforeSave()

    buffers.save()
    
    retVal
  }

  def save(galaxy: Galaxy): SaveResult = {
    save { () => readGalaxy(galaxy) }
    SaveResult(
      playerRows.toSet,
      fsesForExisting
    )
  }

  def initDates() {
    CallbackRow.initPlayerInactivityCheck
    CallbackRow.initAsteroidSpawn
    CallbackRow.initSsUnitsSpawn
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

  private def readGalaxy(galaxy: Galaxy) {
    initDates()
    galaxy.zones.foreach { case (coords, zone) => readZone(galaxy, zone) }
  }

  private def readZone(galaxy: Galaxy, zone: Zone) {
    // Don't read zones without any defined players.
    if (! zone.needsCreation) return

    zone.solarSystems.foreach { 
      case (coords, entry) =>
        entry match {
          case Zone.SolarSystem.New(solarSystem) => {
            val absoluteCoords = zone.absolute(coords)
            readSolarSystem(galaxy, Some(absoluteCoords), solarSystem)
          }
          case Zone.SolarSystem.Existing => ()
        }
    }
  }

  private def startQuests(playerRow: PlayerRow) {
    startQuestIds.foreach { questId =>
      questProgresses += QuestProgressRow(questId, playerRow.id)
    }
    startObjectiveIds.foreach { objectiveId =>
      objectiveProgresses += ObjectiveProgressRow(
        objectiveId, playerRow.id
      )
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
        FowSsEntryRow(ssRow, Some(playerId), None, counter, empty, true)
      }
      else {
        FowSsEntryRow(ssRow, None, Some(allianceId), counter, empty, true)
      }
      fowSsEntries += fowSseRow

      if (! fsesForExisting.contains(ssRow))
        fsesForExisting(ssRow) = ListBuffer.empty[FowSsEntryRow]
      fsesForExisting(ssRow) += fowSseRow
    }
  }

  private var playerRowsCache = Map.empty[Player, PlayerRow]

  private def getPlayerRow(player: Player, galaxyId: Int) = {
    playerRowsCache.get(player) match {
      case Some(playerRow) => playerRow
      case None =>
        val playerRow = new PlayerRow(galaxyId, player)
        players += playerRow
        playerRows += playerRow
        playerRowsCache += player -> playerRow
        playerRow
    }
  }
  
  def readSolarSystem(
    galaxy: Galaxy, coords: Option[Coords], solarSystem: SolarSystem
  ) = {
    val playerRow = solarSystem match {
      case hw: Homeworld => Some(getPlayerRow(hw.player, galaxy.id))
      case _ => None
    }

    val ssRow = new SolarSystemRow(galaxy.id, solarSystem, coords, playerRow)
    solarSystems += ssRow

    // Create solar system units
    solarSystem.units.foreach { case (ssPointCoord, troops) =>
      val location = Location(
        ssRow.id, Location.SolarSystem,
        Some(ssPointCoord.x), Some(ssPointCoord.y)
      )
      troops.foreach { troop =>
        val unitRow = new UnitRow(ssRow.galaxyId, location, troop)
        units += unitRow
      }
    }

    // Create wreckages
    solarSystem.wreckages.foreach { case(ssPointCoord, wreckage) =>
      val location = Location(
        ssRow.id, Location.SolarSystem,
        Some(ssPointCoord.x), Some(ssPointCoord.y)
      )
      val wreckageRow = WreckageRow(ssRow.galaxyId, location, wreckage)
      wreckages += wreckageRow
    }

    def addSpawn() {
      callbacks += CallbackRow(
        ssRow, galaxy.ruleset,
        CallbackRow.Events.Spawn, Calendar.getInstance
      )
    }

    // Add visibility for other players & spawns.
    solarSystem match {
      case _: Homeworld =>
        addSsVisibilityForExistingPlayers(ssRow, false, galaxy, coords.get)

        // Add visibility, player and start quests for that player
        // if this is a homeworld.
        fowSsEntries += FowSsEntryRow(
          ssRow, Some(playerRow.get.id), None, 1, false
        )
        startQuests(playerRow.get)

        // Add player inactivity check
        callbacks += CallbackRow(
          playerRow.get, galaxy.ruleset,
          CallbackRow.Events.CheckInactivePlayer,
          CallbackRow.playerInactivityCheck
        )
        addSpawn() // Spawn callback
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
    ssObjects += ssoRow

    // Create units in ground
    obj.units.foreach { unit =>
      val unitRow = new UnitRow(
        ssRow.galaxyId,
        Location(ssoRow.id, Location.SsObject, None, None),
        unit
      )
      units += unitRow
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

  private def readAsteroid(galaxy: Galaxy, ssoRow: SSObjectRow) {
    callbacks += CallbackRow(
      ssoRow, galaxy.ruleset,
      CallbackRow.Events.Spawn,
      CallbackRow.asteroidSpawn
    )
  }

  private def readPlanet(galaxy: Galaxy, galaxyId: Int, ssoRow: SSObjectRow,
                         planet: Planet) {
    callbacks += CallbackRow(
      ssoRow, galaxy.ruleset,
      CallbackRow.Events.Raid,
      planet.nextRaidAt
    )

    planet.foreachTile { case (coord, kind) =>
        // Only add tiles which mean something.
        if (kind != Planet.TileNormal && kind != Planet.TileVoid) {
          val tileRow = new TileRow(ssoRow, kind, coord.x, coord.y)
          tiles += tileRow
        }
    }

    planet.foreachFolliage { case (coord, kind) =>
        val folliageRow = new TileRow(ssoRow, kind, coord.x, coord.y)
        foliages += folliageRow
    }

    planet.foreachBuilding { building =>
      val buildingRow = new BuildingRow(ssoRow, building)
      buildings += buildingRow

      building.units.foreach { unit =>
        val unitRow = new UnitRow(
          galaxyId,
          Location(buildingRow.id, Location.Building, None, None),
          unit
        )
        units += unitRow
      }
    }
  }
}