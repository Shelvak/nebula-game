package spacemule.modules.pmg.objects.planet

import collection.mutable.ListBuffer
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.Troop
import spacemule.modules.config.objects.{UnitsEntry, Config}

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 15, 2010
 * Time: 11:38:47 AM
 * To change this template use File | Settings | File Templates.
 */

class Building(val name: String, val x: Int, val y: Int, val level: Int=1) {
  val area = Config.getBuildingArea(name)
  val xEnd = x + area.width - 1 // -1 because xEnd is inclusive.
  val yEnd = y + area.height - 1 // -1 because yEnd is inclusive.
  val importance = 0
  val units = ListBuffer[Troop]()

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
  
  def createUnits(entries: Seq[UnitsEntry]) {
    entries.foreach { entry =>
      units ++= entry.createTroops()
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