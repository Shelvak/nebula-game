package spacemule.modules.pmg.objects.ss_objects

import collection.mutable.ListBuffer
import java.awt.Rectangle
import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.HashSet
import spacemule.helpers.Converters._
import spacemule.modules.pmg.classes.ObjectChance
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.classes.geom.area._
import spacemule.modules.pmg.objects.SSObject
import spacemule.modules.pmg.objects.planet._
import spacemule.modules.pmg.objects.planet.buildings._
import spacemule.modules.pmg.objects.planet.tiles._
import spacemule.helpers.Random
import spacemule.helpers.RectFinder
import spacemule.helpers.RandomArray
import spacemule.modules.config.objects.Config

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 9:06:51 PM
 * To change this template use File | Settings | File Templates.
 */

object Planet {
  val TerrainEarth = 0
  val TerrainDesert = 1
  val TerrainMud = 2
  val terrains = IndexedSeq(TerrainEarth, TerrainDesert, TerrainMud)

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

class Planet(planetArea: Int) extends SSObject {
  def this() = this(Config.planetArea)

  val name = "Planet"

  val area = Area.proportional(planetArea, Config.planetProportion)

  /**
   * Importance of planet. It's proportional to planet area and number of
   * resource spots. Area is added here and resource importances are added in
   * increaseImportance()
   */
  var resourcesImportance = 0
  def importance = area.area + resourcesImportance
  val terrainType = Planet.terrains.random

  lazy protected val tilesMap = new AreaMap(area)
  protected val buildings = ListBuffer[Building]()
  // Building occupied tiles
  protected val buildingTiles = HashSet[Coords]()
  protected val folliages = ListBuffer[Folliage]()

  def foreachTile(block: (Coords, Int) => Unit) = tilesMap.foreach(block)
  def foreachFolliage(block: (Coords, Int) => Unit) = {
    folliages.foreach { folliage =>
      block(folliage.coords, folliage.kind)
    }
  }
  def foreachBuilding(block: (Building) => Unit) = buildings.foreach(block)

  /**
   * Fills planet with objects: tiles, folliages and buildings 
   */
  override def initialize() = {
    val finder = new RectFinder(area)
    putResources(finder)
    putNpcBuildings(finder)
    putBlockFolliages(finder)

    putTerrainIsles()
    putFolliage()
  }

  /**
   * Puts block folliages on the map.
   */
  private def putBlockFolliages(finder: RectFinder) = {
    BlockTile.folliageTypes.foreach { blockTile =>
      (1 to Config.planetBlockTileCount(blockTile)).foreach { index =>
        val rectangle = finder.findPlace(blockTile.width, blockTile.height)
        rectangle match {
          case Some(r: Rectangle) => fillBlockTile(blockTile, r)
          // Nothing too bad if there are not enough place to put a block
          // folliage
          case None => ()
        }
      }
    }
  }

  /**
   * Puts resources on the map. Also increases planet importance for each
   * resource tile it adds.
   */
  private def putResources(finder: RectFinder) = {
    BlockTile.resourceTypes.foreach { blockTile =>
      (1 to Config.planetBlockTileCount(blockTile)).foreach { index =>
        // +2 adds border around resource tiles.
        val rectangle = finder.findPlace(blockTile.width + 2,
          blockTile.height + 2)

        rectangle match {
          case Some(r: Rectangle) => {
            // Resource rectangles have borders around them and we don't want
            // to fill these.
            val actual = new Rectangle(
              r.x + 1, r.y + 1, blockTile.width, blockTile.height
            )
            fillBlockTile(blockTile, actual)
            putNpcExtractor(blockTile, actual)
            resourcesImportance += Config.resourceTileImportance(blockTile)
          }
          case None => error("Cannot place resource " + blockTile + "!")
        }
      }
    }
  }

  /**
   * Adds NPC extractor to resource tile.
   */
  private def putNpcExtractor(tile: BlockTile, rectangle: Rectangle) = {
    if (Random.boolean(Config.extractorNpcChance(tile))) {
      val npc = (tile match {
        case BlockTile.Ore =>
          Building.create("NpcMetalExtractor", rectangle.x, rectangle.y)
        case BlockTile.Geothermal =>
          Building.create("NpcGeothermalPlant", rectangle.x, rectangle.y)
        case BlockTile.Zetium =>
          Building.create("NpcZetiumExtractor", rectangle.x, rectangle.y)
      }).asInstanceOf[Npc]
      npc.createUnits(Config.npcBuildingUnitChances)
      buildings += npc
    }
  }

  /**
   * Sets block tile on tilesMap.
   */
  private def fillBlockTile(tile: BlockTile, rectangle: Rectangle) = {
    Planet.fillBlockTile(tilesMap, tile, rectangle.coord)
  }

  /**
   * Puts npc buildings on the map.
   */
  private def putNpcBuildings(finder: RectFinder) = {
    val unitChances = Config.npcBuildingUnitChances
    ObjectChance.foreachByChance(Config.npcBuildingChances, importance) {
      chance =>
              
      val area = Config.getBuildingArea(chance.name)
      val rectangle = finder.findPlace(area)

      rectangle match {
        case Some(r: Rectangle) => {
          val building = Building.create(chance.name, r.x, r.y)
          if (building.isInstanceOf[Npc]) {
            val npc = building.asInstanceOf[Npc]
            npc.createUnits(unitChances)
          }

          buildings += building
          building.eachCoords { coords => buildingTiles += coords }
        }
        // Nothing too bad if there is no space, just ignore it.
        case None => ()
      }
    }
  }

  protected def freeTilesList(
    excludeBuildings: Boolean
  ): RandomArray[Coords] = {
    val free = new RandomArray[Coords](area.area)

    // Populate array with free tiles.
    tilesMap.foreach { (coords, value) =>
      if (
        value == AreaMap.DefaultValue &&
        (! buildingTiles.contains(coords))
      ) {
        free += coords
      }
    }

    return free
  }

  /**
   * Generates terrain isles.
   */
  private def putTerrainIsles() = {
    val free = freeTilesList(false)

    AreaTile.tileCounts(free.size).foreach { case (areaTile, config) =>
      // Don't place regular tiles, they are already there!
      if (areaTile != AreaTile.Regular) {
        val tilesPerIsle = (config.count.toDouble / config.isles).ceil.toInt
        var tilesLeft = config.count

        while (tilesLeft > 0) {
          val placed = placeArea(free, areaTile, tilesPerIsle)
          tilesLeft -= placed
        }
      }
    }
  }

  /**
   * Tries to place count tiles in area.
   */
  private def placeArea(free: RandomArray[Coords], tile: AreaTile,
                        count: Int): Int = {
    // This should never happen because all tile counts are proportional.
    if (free.size < count) {
      error("Cannot place %d tiles when there is only %d left for %s".format(
        count, free.size, tile
      ))
    }

    val possible = new RandomArray[Coords]()

    def addPossible(coords: Coords) = {
      if (coords.x >= 0 && coords.x < area.width && coords.y >= 0
              && coords.y < area.height
              && tilesMap(coords) == AreaMap.DefaultValue
              && ! buildingTiles.contains(coords)
              && ! possible.contains(coords)) {
        possible += coords
      }
    }

    possible += free.random

    var placed = 0
    while (placed < count) {
      // We might return early if we run out of space. Return how much tiles
      // we placed then.
      if (possible.size > 0) {
        val coord = possible.takeRandom
        Planet.setTile(tilesMap, tile, coord)
        free -= coord
        placed += 1

        addPossible(Coords(coord.x + 1, coord.y))
        addPossible(Coords(coord.x - 1, coord.y))
        addPossible(Coords(coord.x, coord.y + 1))
        addPossible(Coords(coord.x, coord.y - 1))
      }
      else {
        return placed
      }
    }

    // At this point places should really == count.
    assert(placed == count)
    return placed
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

    val kinds1stType = Config.folliageKinds1stType(terrainType)
    putFolliages(
      count1stType,
      Config.folliageSpacingRadius1stType,
      () => { kinds1stType.random }
    )

    val kinds2ndType = Config.folliageKinds1stType(terrainType)
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