package spacemule.modules.pmg.persistence

import collection.mutable.{ListBuffer}
import objects._
import spacemule.modules.pmg.objects.{Location, Galaxy, Zone, SolarSystem, SSObject}
import scala.collection.mutable.HashMap
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.ss_objects.{Asteroid, Planet, Homeworld}
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

  private val solarSystemsTable = "solar_systems"
  private val homeworlds = HashMap[Int, Int]()

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

  def save(galaxy: Galaxy): HashMap[Int, Int] = {
    TableIds.initialize()
    clearBuffers()
    homeworlds.clear

    readGalaxy(galaxy)
    saveBuffers()

    return homeworlds
  }

  /**
   * Clears all buffers.
   */
  private def clearBuffers() = {
    List(solarSystems, ssObjects, resourcesEntries, units, buildings,
      folliages, tiles).foreach { buffer => buffer.clear }
  }

  private def saveBuffers() = {
    DB.exec("BEGIN")
    saveBuffer(solarSystemsTable, SolarSystemRow.columns, solarSystems)
    saveBuffer("planets", SSObjectRow.columns, ssObjects)
    saveBuffer("resources_entries", ResourceEntryRow.columns,
               resourcesEntries)
    saveBuffer("tiles", TileRow.columns, tiles)
    saveBuffer("folliages", TileRow.columns, folliages)
    saveBuffer("buildings", BuildingRow.columns, buildings)
    saveBuffer("units", UnitRow.columns, units)
    DB.exec("COMMIT")
  }

  private def saveBuffer(tableName: String, columns: String,
                         items: ListBuffer[String]) = {
    val sql = "INSERT INTO `%s` (%s) VALUES %s".format(
      tableName,
      columns,
      items.mkString(",")
    )
    try {
      DB.exec(sql)
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
    zone.solarSystems.foreach { 
      case (coords, solarSystem) => readSolarSystem(galaxy, zone, coords,
        solarSystem)
    }
  }

  private def readSolarSystem(galaxy: Galaxy, zone: Zone, coords: Coords,
                              solarSystem: SolarSystem) = {
    val ssRow = new SolarSystemRow(galaxy, zone, coords, solarSystem)
    solarSystems += ssRow.values

    solarSystem.objects.foreach {
      case(coords, obj) => readSSObject(galaxy, ssRow, coords, obj)
    }
  }

  private def readSSObject(galaxy: Galaxy, ssRow: SolarSystemRow,
                           coords: Coords, obj: SSObject) = {
    val ssoRow = new SSObjectRow(ssRow, coords, obj)
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

    // Check if this is a homeworld and register it if so.
    if (obj.isInstanceOf[Homeworld]) {
      val homeworld = obj.asInstanceOf[Homeworld]
      homeworlds(homeworld.player.id) = ssoRow.id
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