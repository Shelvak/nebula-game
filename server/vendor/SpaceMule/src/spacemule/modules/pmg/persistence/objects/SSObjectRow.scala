package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.ss_objects._
import spacemule.helpers.Converters._
import spacemule.modules.pmg.objects.SSObject
import spacemule.modules.config.objects.Config
import spacemule.persistence.DB

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 17, 2010
 * Time: 4:51:25 PM
 * To change this template use File | Settings | File Templates.
 */

object SSObjectRow {
  val columns = "`id`, `type`, `solar_system_id`, `angle`, `position`," +
          "`width`, `height`, `terrain`, `player_id`, `name`, `size`, " +
          "`metal`, `metal_rate`, `metal_storage`, " +
          "`energy`, `energy_rate`, `energy_storage`, " +
          "`zetium`, `zetium_rate`, `zetium_storage`"
}

case class SSObjectRow(solarSystemRow: SolarSystemRow, coord: Coords,
                  ssObject: SSObject, playerRow: PlayerRow) {
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
      val range = Config.ssObjectSize
      range.start + (range.end - range.start) * areaPercentage / 100
    }
    case _ => Config.ssObjectSize.random
  }
  val terrain = ssObject match {
    case planet: Planet => planet.terrainType
    case _ => 0
  }
  val playerId = ssObject match {
    case homeworld: Homeworld => playerRow.id.toString
    case _ => DB.loadInFileNull
  }
  val name = ssObject match {
    case planet: Planet => "P-%d".format(id)
    case _ => DB.loadInFileNull
  }

  val values = (
    "%d\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%s\t%s\t%d\t%s"
  ).format(
    id,
    ssObject.name,
    solarSystemRow.id,
    coord.angle,
    coord.position,
    width,
    height,
    terrain,
    playerId,
    name,
    size,
    ssObject match {
      case asteroid: Asteroid =>
        "%d\t%d\t%f\t%d\t%d\t%f\t%d\t%d\t%f".format(
          0, 0, asteroid.metalStorage,
          0, 0, asteroid.energyStorage,
          0, 0, asteroid.zetiumStorage
        )
      case homeworld: Homeworld =>
        "%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f".format(
          Config.homeworldStartingMetal,
          Config.homeworldStartingMetalRate,
          Config.homeworldStartingMetalStorage,
          Config.homeworldStartingEnergy,
          Config.homeworldStartingEnergyRate,
          Config.homeworldStartingEnergyStorage,
          Config.homeworldStartingZetium,
          Config.homeworldStartingZetiumRate,
          Config.homeworldStartingZetiumStorage
        )
      case _ =>
        "%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d".format(
          0, 0, 0,
          0, 0, 0,
          0, 0, 0
        )
    }
  )
}