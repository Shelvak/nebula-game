package spacemule.modules.pmg.objects.ss_objects

import scala.collection.mutable.ListBuffer
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.classes.geom.area.{Area, AreaMap}
import spacemule.modules.pmg.objects.planet._
import buildings.Npc
import spacemule.modules.pmg.objects.Player
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.objects.planet.tiles.AreaTile
import spacemule.modules.pmg.objects.planet.tiles.BlockTile

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 14, 2010
 * Time: 12:08:02 PM
 * To change this template use File | Settings | File Templates.
 */

case class HomeworldData(tilesMap: AreaMap, buildings: ListBuffer[Building])

object Homeworld {
  lazy val data: HomeworldData = parseMap(Config.homeworldMap)

  private def parseMap(map: List[String]): HomeworldData = {
    val area = Area(map(0).length() / 2, map.length)
    val tilesMap = new AreaMap(area)
    val buildings = ListBuffer[Building]()

    (0 until area.height).foreach { row =>
      (0 until area.width).foreach { col =>
        val stringIndex = col * 2
        val coord = Coords(col, row)
        setTile(tilesMap, coord,
          map(row).substring(stringIndex, stringIndex + 1))
        setBuilding(buildings, coord,
          map(row).substring(stringIndex + 1, stringIndex + 2))
      }
    }

    return HomeworldData(tilesMap, buildings)
  }

  private def setTile(tilesMap: AreaMap, coord: Coords, char: String) {
    val tile: Tile = char.toLowerCase match {
      case "." | "-" => null
      case "o" => BlockTile.Ore
      case "%" => BlockTile.Geothermal
      case "$" => BlockTile.Zetium
      case "6" => BlockTile.Folliage6X6
      case "^" => BlockTile.Folliage6X2
      case "4" => BlockTile.Folliage4X6
      case "@" => BlockTile.Folliage4X4
      case "!" => BlockTile.Folliage4X3
      case "3" => BlockTile.Folliage3X3
      case "#" => BlockTile.Folliage3X4
      case "s" => AreaTile.Sand
      case "j" => AreaTile.Junkyard
      case "n" => AreaTile.Noxrium
      case "t" => AreaTile.Titan
      case "w" => AreaTile.Water
      case _ => error("Unknown homeworld map signature " + char)
    }

    if (tile != null) {
      Planet.setTile(tilesMap, tile, coord)
    }
  }

  private def setBuilding(buildings: ListBuffer[Building], coord: Coords,
                          char: String) = {
    val name = char.toLowerCase match {
      case " " | "-" => null
      case "m" => "Mothership"
      case "v" => "Vulcan"
      case "s" => "Screamer"
      case "t" => "Thunder"
      case "x" => "NpcMetalExtractor"
      case "g" => "NpcGeothermalPlant"
      case "z" => "NpcZetiumExtractor"
      case "p" => "NpcSolarPlant"
      case "h" => "NpcCommunicationsHub"
      case "e" => "NpcTemple"
      case "c" => "NpcExcavationSite"
      case "r" => "NpcResearchCenter"
      case "u" => "NpcJumpgate"
      case _ => error("Unknown homeworld building signature " + char)
    }

    if (name != null) {
      val building = Building.create(name, coord.x, coord.y)
      if (building.isInstanceOf[Npc]) {
        val npc = building.asInstanceOf[Npc]
        npc.createUnits(Config.npcHomeworldBuildingUnitChances)
      }
      buildings += building
    }
  }
}

class Homeworld(val player: Player) extends Planet {
  override def importance = 0
  override val terrainType = Planet.TerrainEarth
  override protected val tilesMap = Homeworld.data.tilesMap
  override protected val buildings = Homeworld.data.buildings

  override def initialize() = {
    putFolliage(freeTilesList)
  }
}