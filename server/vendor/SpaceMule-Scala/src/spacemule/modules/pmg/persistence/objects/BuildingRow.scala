package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.pmg.objects.planet.Building
import spacemule.modules.config.objects.Config

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 17, 2010
 * Time: 8:16:48 PM
 * To change this template use File | Settings | File Templates.
 */

object BuildingRow {
  val columns = "`id`, `type`, `planet_id`, `x`, `y`, `x_end`, `y_end`, " +
  "`armor_mod`, `construction_mod`, `energy_mod`, `constructor_mod`, " +
  "`level`, `hp`"
}

case class BuildingRow(planetRow: SSObjectRow, building: Building) {
  val id = TableIds.building.next

  val values = (
    "(%d, '%s', %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d)"
  ).format(
    id,
    building.name,
    planetRow.id,
    building.x,
    building.y,
    building.xEnd,
    building.yEnd,
    0, 0, 0, 0, 1,
    Config.buildingHp(building)
  )
}