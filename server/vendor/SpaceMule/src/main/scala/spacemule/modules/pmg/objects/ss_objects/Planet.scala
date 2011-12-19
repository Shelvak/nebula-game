package spacemule.modules.pmg.objects.ss_objects

import java.math.BigDecimal
import spacemule.helpers.Converters._
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.classes.geom.area._
import spacemule.modules.pmg.objects.SSObject
import spacemule.modules.pmg.objects.planet._
import spacemule.modules.pmg.objects.planet.tiles._
import spacemule.helpers.RandomArray
import scala.{collection => sc}
import collection.mutable.{HashSet, ListBuffer, ArrayBuffer}
import spacemule.modules.config.objects.{UnitsEntry, Config}

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
    def extract(data: sc.Seq[Any]): MapSet = {
      MapSet(data.toIndexedSeq.map { mapData =>
        Map.extract(mapData.asInstanceOf[sc.Map[String, Any]])
      })
    }
  }

  case class MapSet(maps: IndexedSeq[Map])

  object Map {
    /**
     * Extract a map from dynamic data structure like this:
     *
     {
       'size' => [width, height],
       'name' => String,
       'terrain' => Fixnum,
       'tiles' => {
         kind (Fixnum) => [[x, y], ...]
       },
       'buildings' => {
         building_name (String) => [[x, y, units], ...]
       }
     }
     */
    def extract(data: sc.Map[String, Any]): Map = {
      val size = data("size").asInstanceOf[IndexedSeq[Long]]
      val area = Area(size(0).toInt, size(1).toInt)

      val name = data("name").asInstanceOf[String]
      val terrainKind = data("terrain").asInstanceOf[Long].toInt

      val tilesMap = new AreaMap(area)
      data("tiles").asInstanceOf[
        sc.Map[Long, Seq[
          IndexedSeq[Long]
        ]]
      ].foreach { case (tileKind, tiles) =>
        val tile = Tile(tileKind.toInt)
        tiles.foreach { coordArray =>
          val coord = Coords(coordArray(0).toInt, coordArray(1).toInt)
          Planet.setTile(tilesMap, tile, coord)
        }
      }

      val (buildings, buildingTiles) =
        data("buildings").asInstanceOf[
          sc.Map[String, Seq[IndexedSeq[Any]]]
        ].foldLeft(
          (ListBuffer.empty[Building], HashSet.empty[Coords])
        ) { case ((b, bt), (buildingName, dataArray)) =>
          dataArray.foreach { entryArray =>
            val x = entryArray(0).asInstanceOf[Long].toInt
            val y = entryArray(1).asInstanceOf[Long].toInt
            val units = UnitsEntry.extract(entryArray(2))

            val building = new Building(buildingName, x, y, 1)
            building.createUnits(units)
            b += building
            building.eachCoords { coords => bt += coords }
          }

          (b, bt)
        }

      Map(area, name, terrainKind, tilesMap, buildings.toSeq, buildingTiles.toSet)
    }
  }

  case class Map(
    area: Area,
    name: String,
    terrain: Int,
    tilesMap: AreaMap,
    buildings: Seq[Building],
    // Building occupied tiles. Used in populating free are with folliage.
    buildingTiles: Set[Coords]
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
        tilesMap(Coords(x, y)) = Planet.TileVoid
      }
    }

    // Set starting block to kind
    tilesMap(coords) = tile.kind
  }
}

class Planet(map: Planet.Map) extends SSObject {
  def this() = this(Config.randomFree)

  private[this] val folliages = ListBuffer[Folliage]()

  val name = "Planet"

  def foreachTile(block: (Coords, Int) => Unit) = map.tilesMap.foreach(block)
  def foreachFolliage(block: (Coords, Int) => Unit) = {
    folliages.foreach { folliage =>
      block(folliage.coords, folliage.kind)
    }
  }
  def foreachBuilding(block: (Building) => Unit) = map.buildings.foreach(block)

  private def buildingsPropSum(f: (Building) => BigDecimal) = 
    map.buildings.foldLeft(0.0) {
      case (sum, building) => sum + f(building).doubleValue()
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

  /**
   * Fills planet with folliage.
   */
  override def initialize() = putFolliage()

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
    def putFolliages(count: Int, radius: Int, kind: () => Int) = {
      if (free.size > 0) {
        // We'll keep free spots for local type here
        val localFree = free.clone

        (1 to count).foreach { index =>
          if (localFree.size > 0) {
            val coords = localFree.takeRandom
            folliages += Folliage(kind(), coords)
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
    putFolliages(
      count1stType,
      Config.folliageSpacingRadius1stType,
      () => { kinds1stType.random }
    )

    val kinds2ndType = Config.folliageKinds1stType(map.terrain)
    putFolliages(
      count2ndType,
      Config.folliageSpacingRadius2ndType,
      () => { kinds2ndType.random }
    )

    val kinds3rdType = new ArrayBuffer[Int]()
    kinds3rdType ++= (0 until Config.folliageVariations)
    kinds3rdType --= kinds1stType
    kinds3rdType --= kinds2ndType
    
    putFolliages(
      count3rdType,
      0,
      () => { kinds3rdType.random }
    )
  }
}