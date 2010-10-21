package spacemule.modules.pmg.objects.planet

import buildings._
import spacemule.modules.config.objects.Config
import collection.mutable.ListBuffer
import spacemule.modules.pmg.objects.Unit

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 15, 2010
 * Time: 11:38:47 AM
 * To change this template use File | Settings | File Templates.
 */

object Building {
  def create(name: String, x: Int, y: Int): Building = {
    return name match {
      case "Mothership" | "Screamer" | "Thunder" | "Vulcan" =>
        new buildings.Player(name, x, y)
      case "NpcMetalExtractor" | "NpcGeothermalPlant" | "NpcZetiumExtractor" |
              "NpcSolarPlant" | "NpcCommunicationsHub" | "NpcTemple" |
              "NpcExcavationSite" | "NpcResearchCenter" | "NpcJumpgate" =>
        new buildings.Npc(name, x, y)
    }
  }
}

class Building(val name: String, val x: Int, val y: Int) {
  val area = Config.getBuildingArea(name)
  val xEnd = x + area.width
  val yEnd = y + area.height
  val importance = 0
  val units = ListBuffer[Unit]()

  override def hashCode(): Int = {
    x * 7 + y * 7 + name.hashCode
  }

  override def equals(other: Any) = {
    other.isInstanceOf[Building] && {
      val building = other.asInstanceOf[Building]
      x == building.x && y == building.y && name == building.name
    }
  }

  def initialize() = {}
}