package spacemule.modules.pmg.objects.planet

import buildings._
import spacemule.modules.config.objects.Config
import collection.mutable.ListBuffer
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.Unit

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 15, 2010
 * Time: 11:38:47 AM
 * To change this template use File | Settings | File Templates.
 */

object Building {
  // Player controlled buildings

  val Mothership = "Mothership"
  val Screamer = "Screamer"
  val Thunder = "Thunder"
  val Vulcan = "Vulcan"

  // These buildings are NPC origin, but players control them

  val NpcHall = "NpcHall"
  val NpcInfantryFactory = "NpcInfantryFactory"
  val NpcTankFactory = "NpcTankFactory"
  val NpcSpaceFactory = "NpcSpaceFactory"

  // NPC buildings

  val NpcMetalExtractor = "NpcMetalExtractor"
  val NpcGeothermalPlant = "NpcGeothermalPlant"
  val NpcZetiumExtractor = "NpcZetiumExtractor"
  val NpcSolarPlant = "NpcSolarPlant"
  val NpcCommunicationsHub = "NpcCommunicationsHub"
  val NpcTemple = "NpcTemple"
  val NpcExcavationSite = "NpcExcavationSite"
  val NpcResearchCenter = "NpcResearchCenter"
  val NpcJumpgate = "NpcJumpgate"

  def create(name: String, x: Int, y: Int): Building = {
    val building = name match {
      case Mothership | Screamer | Thunder | Vulcan | NpcHall |
        NpcInfantryFactory | NpcTankFactory | NpcSpaceFactory =>
        new buildings.Player(name, x, y)
      case NpcMetalExtractor | NpcGeothermalPlant | NpcZetiumExtractor | 
        NpcSolarPlant | NpcCommunicationsHub | NpcTemple | NpcExcavationSite |
        NpcResearchCenter | NpcJumpgate =>
        new buildings.Npc(name, x, y)
    }
    return building
  }
}

class Building(val name: String, val x: Int, val y: Int) {
  val area = Config.getBuildingArea(name)
  val xEnd = x + area.width - 1 // -1 because xEnd is inclusive.
  val yEnd = y + area.height - 1 // -1 because yEnd is inclusive.
  val importance = 0
  val units = ListBuffer[Unit]()

  /**
   * Yields each coordinate that building is standing on.
   */
  def eachCoords(block: (Coords) => scala.Unit) = {
    (x to xEnd).foreach { x =>
      (y to yEnd).foreach { y =>
        block(Coords(x, y))
      }
    }
  }

  override def hashCode(): Int = {
    x * 7 + y * 7 + name.hashCode
  }

  override def equals(other: Any) = {
    other.isInstanceOf[Building] && {
      val building = other.asInstanceOf[Building]
      x == building.x && y == building.y && name == building.name
    }
  }
}