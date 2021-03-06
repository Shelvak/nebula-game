package spacemule.modules.pmg.objects.ss_objects

import spacemule.helpers.Converters._
import core.Values._
import core.AnyConversions._
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.classes.geom.area._
import spacemule.modules.pmg.objects.SSObject
import spacemule.modules.pmg.objects.planet._
import spacemule.modules.pmg.objects.planet.tiles._
import spacemule.helpers.RandomArray
import scala.{collection => sc}
import spacemule.modules.config.objects.{ResourcesEntry, UnitsEntry, Config}
import scala.collection.mutable.{HashSet, ListBuffer, ArrayBuffer}

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 9:06:51 PM
 * To change this template use File | Settings | File Templates.
 */

object Planet {
  object MapSet {
    /**
     * Extract a map set from ruby config.
     */
    def extract(data: sc.Seq[sc.Map[String, Any]]) = {
      val maps = data.mapWithIndex { case (mapData, index) =>
        val extracted = try {
          Map.extract(mapData)
        }
        catch {
          case e: Exception => throw new IllegalArgumentException(
            "Error while extracting mapset entry %d:\n%s".format(
              index, e.getMessage
            ), e
          )
        }
        extracted
      }.toIndexedSeq
      new MapSet(maps)
    }
  }

  class MapSet(maps: IndexedSeq[Map]) {
    private[this] val weights = maps.map(_.weight)

    def random = maps.weightedRandom(weights)
  }

  object Map {
    /**
     * Extract a map from dynamic data structure like this:
     *
    {
       'size' => [width, height],
       'name' => String,
       'terrain' => Fixnum,
       'weight' => Fixnum,
       'tiles' => {
         kind (Fixnum) => [ [x, y], ...]
       },
       'buildings' => {
         building_name (String) => [ [x, y, units], ...]
       },
       'units' => UnitsEntry configuration
     }
     */
    def extract(data: sc.Map[String, Any]): Map = {
      try {
        val size = data("size").asInstanceOf[sc.Seq[Long]]
        val area = Area(size(0), size(1))

        val name = data("name").toString
        val terrainKind = data("terrain").asInt

        val tilesMap = new AreaMap(area)

        data("tiles").asInstanceOf[
          sc.Map[Long, sc.Seq[sc.Seq[Long]]]
        ].foreach { case (tileKind, tiles) =>
          val tile = Tile(tileKind)
          tiles.foreach { coordArray =>
            val coord = Coords(coordArray(0), coordArray(1))
            try {
              Planet.setTile(tilesMap, tile, coord)
            }
            catch {
              case e: Exception =>
                throw new IllegalArgumentException(
                  "Error while setting %s at %s:\n%s".format(
                    tile, coord, e.getMessage
                  ), e
                )
            }
          }
        }

        val weight = data("weight").asInt
        val resources = ResourcesEntry.extract(
          data("resources").asInstanceOf[sc.Seq[Double]]
        )

        val (buildings, buildingTiles) =
          data("buildings").asInstanceOf[
            sc.Map[String, sc.Seq[sc.Seq[Any]]]
          ].foldLeft(
            (ListBuffer.empty[Building], HashSet.empty[Coords])
          ) { case ((b, bt), (buildingName, dataArray)) =>
            dataArray.foreach { entryArray =>
              val x = entryArray(0).asInt
              val y = entryArray(1).asInt
              val level = entryArray(2).asInt
              val units = UnitsEntry.extract(
                entryArray(3).asInstanceOf[sc.Seq[sc.Seq[Any]]]
              )

              val building = new Building(buildingName.toString, x, y, level)
              building.createUnits(units)
              b += building
              building.eachCoords { coords => bt += coords }
            }

            (b, bt)
          }

        val units = UnitsEntry.extract(
          data("units").asInstanceOf[sc.Seq[sc.Seq[Any]]]
        )

        Map(
          area, name, terrainKind, weight, resources, tilesMap, buildings.toSeq,
          buildingTiles.toSet, units
        )
      }
      catch {
        case e: Exception =>
          throw new IllegalArgumentException(
            "Error while extracting planet map definition from:\n\n%s\n\n%s".
              format(data, e.getMessage),
            e
          )
      }
    }
  }

  case class Map(
    area: Area,
    name: String,
    terrain: Int,
    weight: Int,
    resources: ResourcesEntry,
    tilesMap: AreaMap,
    buildings: Seq[Building],
    // Building occupied tiles. Used in populating free are with folliage.
    buildingTiles: Set[Coords],
    units: Seq[UnitsEntry]
  )

  val TileNormal = AreaMap.DefaultValue

  /**
   * Means void tile where nothing else can be placed.
   */
  val TileVoid = -2

  def setTile(tilesMap: AreaMap, tile: Tile, coords: Coords) {
    tile match {
      case tile: AreaTile => tilesMap(coords) = tile.kind
      case tile: BlockTile => fillBlockTile(tilesMap, tile, coords)
    }
  }

  def fillBlockTile(tilesMap: AreaMap, tile: BlockTile, coords: Coords) {
    // Fill blocks with void
    (coords.x until (coords.x + tile.width)).foreach { x =>
      (coords.y until (coords.y + tile.height)).foreach { y =>
        tilesMap(Coords(x, y)) = TileVoid
      }
    }

    // Set starting block to kind
    tilesMap(coords) = tile.kind
  }
}

class Planet(val map: Planet.Map, val ownedByPlayer: Boolean = false)
extends SSObject {
  private[this] val foliages = ListBuffer[Folliage]()

  val name = "Planet"
  
  def planetName(id: Int) = map.name.format(id.toString(Character.MAX_RADIX))

  def foreachTile(block: (Coords, Int) => Unit) = map.tilesMap.foreach(block)
  def foreachFolliage(block: (Coords, Int) => Unit) = {
    foliages.foreach { folliage =>
      block(folliage.coords, folliage.kind)
    }
  }
  def foreachBuilding(block: (Building) => Unit) = map.buildings.foreach(block)

  private def buildingsPropSum(f: (Building) => Double) =
    map.buildings.foldLeft(0.0) {
      case (sum, building) => sum + f(building)
    }
  
  def metalGenerationRate = 
    buildingsPropSum(Config.buildingMetalGenerationRate)
  def energyGenerationRate = 
    buildingsPropSum(Config.buildingEnergyGenerationRate)
  def zetiumGenerationRate = 
    buildingsPropSum(Config.buildingZetiumGenerationRate)
  
  def metalUsageRate = buildingsPropSum(Config.buildingMetalUsageRate)
  def energyUsageRate = buildingsPropSum(Config.buildingEnergyUsageRate)
  def zetiumUsageRate = buildingsPropSum(Config.buildingZetiumUsageRate)
  
  def metalStorage = buildingsPropSum(Config.buildingMetalStorage)
  def energyStorage = buildingsPropSum(Config.buildingEnergyStorage)
  def zetiumStorage = buildingsPropSum(Config.buildingZetiumStorage)

  lazy val nextRaidAt = Config.raidingDelayRandomDate

  putFolliage()

  // Create ground troops
  map.units.foreach { unitsEntry =>
    _units = _units ++ unitsEntry.createTroops()
  }

  protected def freeTilesList(
    excludeBuildings: Boolean
  ): RandomArray[Coords] = {
    val free = new RandomArray[Coords](map.area.area)

    // Populate array with free tiles.
    map.tilesMap.foreach { (coords, value) =>
      if (
        value == AreaMap.DefaultValue &&
        (! map.buildingTiles.contains(coords))
      ) {
        free += coords
      }
    }

    return free
  }

  protected def putFolliage() = {
    val free = freeTilesList(true)

    /**
     * This type requires spacing around them.
     */
    def putFoliages(count: Int, radius: Int, kind: () => Int) = {
      if (free.size > 0) {
        // We'll keep free spots for local type here
        val localFree = free.clone

        (1 to count).foreach { index =>
          if (localFree.size > 0) {
            val coords = localFree.takeRandom
            foliages += Folliage(kind(), coords)
            free -= coords

            // Remove everything around it in spacing radius.
            (-radius to radius).foreach { x =>
              (-radius to radius).foreach { y =>
                localFree -=! Coords(coords.x + x, coords.y + y)
              }
            }
          }
        }
      }
    }

    val totalCount = free.size * Config.folliagePercentage / 100
    val count1stType = Config.folliageCount1stType
    val count2ndType = totalCount * Config.folliagePercentage2ndType / 100
    val count3rdType = totalCount - count1stType - count2ndType

    val kinds1stType = Config.folliageKinds1stType(map.terrain)
    putFoliages(
      count1stType,
      Config.folliageSpacingRadius1stType,
      () => { kinds1stType.random }
    )

    val kinds2ndType = Config.folliageKinds1stType(map.terrain)
    putFoliages(
      count2ndType,
      Config.folliageSpacingRadius2ndType,
      () => { kinds2ndType.random }
    )

    val kinds3rdType = new ArrayBuffer[Int]()
    kinds3rdType ++= (0 until Config.folliageVariations)
    kinds3rdType --= kinds1stType
    kinds3rdType --= kinds2ndType
    
    putFoliages(
      count3rdType,
      0,
      () => { kinds3rdType.random }
    )
  }
}