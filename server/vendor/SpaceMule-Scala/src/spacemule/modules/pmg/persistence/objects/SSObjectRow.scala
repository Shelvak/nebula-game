package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.ss_objects._
import spacemule.helpers.Converters._
import spacemule.modules.pmg.objects.SSObject
import spacemule.modules.config.objects.Config

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 17, 2010
 * Time: 4:51:25 PM
 * To change this template use File | Settings | File Templates.
 */

object SSObjectRow {
  val columns = "`id`, `type`, `solar_system_id`, `angle`, `position`," +
          "`width`, `height`, `variation`, `player_id`, `name`, `size`"
}

case class SSObjectRow(solarSystemRow: SolarSystemRow, coord: Coords,
                  ssObject: SSObject) {
  val id = TableIds.ssObject.next
  val width = ssObject match {
    case planet: Planet => planet.area.width
    case _ => 0
  }
  val height = ssObject match {
    case planet: Planet => planet.area.height
    case _ => 0
  }
  val size = ssObject match {
    case planet: Planet => {
      val areaPercentage = planet.area.edgeSum * 100 / Config.planetAreaMax
      val range = Config.planetSize
      range.start + (range.end - range.start) * areaPercentage / 100
    }
    case _ => Config.planetSize.random
  }
  val variation = ssObject match {
    case planet: Planet => planet.terrainType
    case _ => 0
  }
  val playerId = ssObject match {
    case homeworld: Homeworld => homeworld.player.id.toString
    case _ => "NULL"
  }
  val name = ssObject match {
    case richAsteroid: RichAsteroid => "RA-%d".format(id)
    case asteroid: Asteroid => "A-%d".format(id)
    case planet: Planet => "P-%d".format(id)
    case jumpgate: Jumpgate => "JG-%d".format(id)
  }

  val values = (
    "(%d, '%s', %d, %d, %d, %d, %d, %d, %s, '%s', %d)"
  ).format(
    id,
    ssObject.getClass.getSimpleName,
    solarSystemRow.id,
    coord.angle,
    coord.position,
    width,
    height,
    variation,
    playerId,
    name,
    size
  )
}