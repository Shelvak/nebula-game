package spacemule.modules.pmg.persistence

import manager.{ReferableBuffer, Buffer, BufferManager}
import objects._
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.ss_objects.Planet
import spacemule.persistence.DB
import java.util.{Calendar, Date}
import spacemule.modules.pmg.objects._
import spacemule.helpers.JRuby._
import solar_systems.Wormhole
import spacemule.logging.Log

object Manager {
  val GalaxiesTable = RClass("Galaxy").callMethod("table_name").toString
  val PlayersTable = RClass("Player").callMethod("table_name").toString
  val SolarSystemsTable =
    RClass("SolarSystem").callMethod("table_name").toString
  val SolarSystemObjectsTable =
    RClass("SsObject").callMethod("table_name").toString
  val TilesTable = RClass("Tile").callMethod("table_name").toString
  val FoliagesTable = RClass("Folliage").callMethod("table_name").toString
  val BuildingsTable = RClass("Building").callMethod("table_name").toString
  val UnitsTable = RClass("Unit").callMethod("table_name").toString
  val WreckagesTable = RClass("Wreckage").callMethod("table_name").toString
  val CallbacksTable = RClass("Callback").getConstant("TABLE_NAME").toString

  val solarSystems = new ReferableBuffer(SolarSystemsTable, SolarSystemRow)
  val ssObjects = new ReferableBuffer(SolarSystemObjectsTable, SSObjectRow)
  val tiles = new Buffer(TilesTable, TileRow)
  val foliages = new Buffer(FoliagesTable, TileRow)
  val buildings = new ReferableBuffer(BuildingsTable, BuildingRow)
  val units = new Buffer(UnitsTable, UnitRow)
  val wreckages = new Buffer(WreckagesTable, WreckageRow)
  val callbacks = new Buffer(CallbacksTable, CallbackRow)

  val buffers = new BufferManager(
    // Ordered by FKs.
    solarSystems,
    ssObjects,
    tiles,
    foliages,
    buildings,
    units,
    wreckages,
    callbacks
  )

  /**
   * Current date to use in fields where NOW() is required.
   */
  var currentDateTime = "0000-00-00 00:00:00"

  /**
   * Load current solar systems to avoid clashes.
   */
  def load(galaxy: Galaxy) {
    loadSolarSystems(galaxy)
  }

  private def loadSolarSystems(galaxy: Galaxy) {
    // String variables
    val now = DB.date(Calendar.getInstance())
    val ss = SolarSystemsTable
    val p = PlayersTable

    // Select attached solar systems
    def selectAttached() {
      DB.query("""
SELECT
  """+ss+""".`x`,
  """+ss+""".`y`,
  """+ss+""".`player_id`,
  IF("""+p+""".`created_at`, TO_SECONDS('#now') - TO_SECONDS("""+p+
    """.`created_at`), 0) AS age
FROM `"""+ss+"""`
LEFT JOIN `"""+p+"""` ON """+ss+""".`player_id`="""+p+""".`id`
WHERE """+ss+""".`galaxy_id`=#galaxy.id AND """+ss+""".`kind`="""+
  SolarSystem.Normal.id+""" AND
  """+ss+""".`x` IS NOT NULL AND """+ss+""".`y` IS NOT NULL"""
      ) { rs =>
        while (rs.next) {
          val x = rs.getInt(1)
          val y = rs.getInt(2)
          val playerId = rs.getInt(3)
          val age = rs.getInt(4)

          galaxy.addExistingSS(x, y, playerId, age)
        }
      }
    }

    def selectPooled() {
      DB.query("""
SELECT COUNT(*) FROM `"""+ss+"""`
WHERE """+ss+""".`galaxy_id`="""+galaxy.id+""" AND """+ss+""".`kind`="""+
SolarSystem.Pooled.id
      ) { rs =>
        while (rs.next()) { galaxy.addPooledHomeSystems(rs.getInt(1)) }
      }
    }

    selectAttached()
    selectPooled()
  }

//  private def loadQuests(): Seq[Int] = {
//    Log.block("Loading quests", level=Log.Debug) { () =>
//      DB.getCol[Int](
//        "SELECT `id` FROM `%s` WHERE `parent_id` IS NULL".format(QuestsTable)
//      )
//    }
//  }
//
//  private def loadObjectives(): Seq[Int] = {
//    Log.block("Loading objectives", level=Log.Debug) { () =>
//      if (startQuestIds.isEmpty) Seq[Int]()
//      else DB.getCol[Int](
//        "SELECT `id` FROM `%s` WHERE `quest_id` IN (%s)".format(
//          ObjectivesTable, startQuestIds.mkString(",")
//        )
//      )
//    }
//  }

  def save[T](beforeSave: () => T): T = {
    buffers.clear()
    currentDateTime = DB.date(new Date())

    // Run something before save if provided
    val retVal = beforeSave()

    Log.block("Saving buffers", level=Log.Debug) { () => buffers.save() }
    
    retVal
  }

  def save(galaxy: Galaxy) {
    save { () =>
      Log.block("Reading galaxy into buffers", level=Log.Debug) { () =>
        readGalaxy(galaxy)
      }
    }
  }

  def initDates() {
    CallbackRow.initAsteroidSpawn
    CallbackRow.initSsUnitsSpawn
  }

  private[this] def readGalaxy(galaxy: Galaxy) {
    initDates()
    galaxy.battleground.foreach { bg => readSolarSystem(galaxy, None, bg) }
    galaxy.zones.foreach { case (coords, zone) =>
      readZone(galaxy, zone)
    }
    galaxy.pooledHomeSystems.foreach { ss =>
      readSolarSystem(galaxy, None, ss)
    }
  }

  private def readZone(galaxy: Galaxy, zone: Zone) {
    // Don't read zones without any defined players.
    if (! zone.needsCreation) return

    Log.block("Reading " + zone, level=Log.Debug) { () =>
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
  }
  
  private[this] def readSolarSystem(
    galaxy: Galaxy, coords: Option[Coords], solarSystem: SolarSystem
  ) = {
    Log.debug("Creating row for "+solarSystem+" @ "+coords)
    val ssRow = new SolarSystemRow(galaxy.id, solarSystem, coords)
    solarSystems += ssRow

    // Create solar system units
    solarSystem.units.foreach { case (ssPointCoord, troops) =>
      val location = Location(
        ssRow, Location.SolarSystem,
        Some(ssPointCoord.x), Some(ssPointCoord.y)
      )
      troops.foreach { troop =>
        val unitRow = new UnitRow(location, troop)
        units += unitRow
      }
    }

    // Create wreckages
    solarSystem.wreckages.foreach { case(ssPointCoord, wreckage) =>
      val location = Location(
        ssRow, Location.SolarSystem,
        Some(ssPointCoord.x), Some(ssPointCoord.y)
      )
      val wreckageRow = WreckageRow(location, wreckage)
      wreckages += wreckageRow
    }

    // Add visibility for other players & spawns.
    solarSystem match {
      case _: Wormhole => ()
      case _ =>
        callbacks += CallbackRow(
          ssRow, galaxy.ruleset,
          CallbackRow.Events.Spawn, Calendar.getInstance
        )
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
        Location(ssoRow, Location.SsObject, None, None),
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
          Location(buildingRow, Location.Building, None, None),
          unit
        )
        units += unitRow
      }
    }
  }
}