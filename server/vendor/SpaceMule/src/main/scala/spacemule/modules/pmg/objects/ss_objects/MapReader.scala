/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.objects.ss_objects

import scala.collection.mutable.HashSet
import scala.collection.mutable.ListBuffer
import spacemule.modules.pmg.classes.UnitChance
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.classes.geom.area.Area
import spacemule.modules.pmg.classes.geom.area.AreaMap
import spacemule.modules.pmg.objects.planet.Building
import spacemule.modules.pmg.objects.planet.Tile
import spacemule.modules.pmg.objects.planet.buildings.Npc
import spacemule.modules.pmg.objects.planet.tiles.AreaTile
import spacemule.modules.pmg.objects.planet.tiles.BlockTile

case class MapData(area: Area, tilesMap: AreaMap,
                         buildings: ListBuffer[Building],
                         buildingTiles: HashSet[Coords])

/**
 * Used in reading maps from config.
 */
object MapReader {
  def parseMap(map: Seq[String],
               npcBuildingChances: Seq[UnitChance],
               buildingLevel: Int = 1): MapData = {
    val area = Area(map(0).length() / 2, map.length)
    val tilesMap = new AreaMap(area)
    val buildings = ListBuffer[Building]()
    val buildingTiles = HashSet[Coords]()

    (0 until area.height).foreach { row =>
      (0 until area.width).foreach { col =>
        val stringIndex = col * 2
        val coord = Coords(col, row)
        setTile(tilesMap, coord,
          map(row).substring(stringIndex, stringIndex + 1))
        setBuilding(buildings, buildingTiles, coord,
          map(row).substring(stringIndex + 1, stringIndex + 2),
          npcBuildingChances, buildingLevel)
      }
    }

    return MapData(area, tilesMap, buildings, buildingTiles)
  }

  private def setTile(tilesMap: AreaMap, coord: Coords, char: String) {
    val tile: Tile = char.toLowerCase match {
      case "." | "-" => null
      case "o" => BlockTile.Ore
      case "%" => BlockTile.Geothermal
      case "$" => BlockTile.Zetium
      case "6" => BlockTile.Folliage6X6
      case "~" => BlockTile.Folliage6X2
      case "4" => BlockTile.Folliage4X6
      case "@" => BlockTile.Folliage4X4
      case "!" => BlockTile.Folliage4X3
      case "3" => BlockTile.Folliage3X3
      case "*" => BlockTile.Folliage3X4
      case "_" => AreaTile.Sand
      case "#" => AreaTile.Junkyard
      case "/" => AreaTile.Noxrium
      case "^" => AreaTile.Titan
      case _ => sys.error("Unknown map signature " + char)
    }

    if (tile != null) {
      Planet.setTile(tilesMap, tile, coord)
    }
  }

  private def setBuilding(buildings: ListBuffer[Building],
                          buildingTiles: HashSet[Coords],
                          coord: Coords,
                          char: String,
                          chances: Seq[UnitChance],
                          level: Int) = {
    val name = char match {
      case " " | "-" => null
      case "m" => Building.Mothership
      case "h" => Building.Headquarters
      case "x" => Building.MexT2
      case "c" => Building.CollectorT2
      case "z" => Building.ZexT2
      case "X" => Building.NpcMetalExtractor
      case "G" => Building.NpcGeothermalPlant
      case "Z" => Building.NpcZetiumExtractor
      case "P" => Building.NpcSolarPlant
      case "H" => Building.NpcCommunicationsHub
      case "E" => Building.NpcTemple
      case "C" => Building.NpcExcavationSite
      case "R" => Building.NpcResearchCenter
      case "U" => Building.NpcJumpgate
      case "a" => Building.NpcHall
      case "i" => Building.NpcInfantryFactory
      case "n" => Building.NpcTankFactory
      case "f" => Building.NpcSpaceFactory
      case _ => sys.error("Unknown homeworld building signature " + char)
    }

    if (name != null) {
      val building = Building.create(name, coord.x, coord.y, level)
      if (building.isInstanceOf[Npc]) {
        val npc = building.asInstanceOf[Npc]
        npc.createUnits(chances)
      }
      buildings += building
      building.eachCoords { coords => buildingTiles += coords }
    }
  }
}
