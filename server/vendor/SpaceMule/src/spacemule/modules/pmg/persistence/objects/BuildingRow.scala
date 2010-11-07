package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.pmg.objects.planet.Building
import spacemule.modules.config.objects.Config

object BuildingRow {
  val columns = "`id`, `type`, `planet_id`, `x`, `y`, `x_end`, `y_end`, " +
  "`armor_mod`, `construction_mod`, `energy_mod`, `constructor_mod`, " +
  "`level`, `hp`, `state`"

  val StateActive = 1
}

case class BuildingRow(planetRow: SSObjectRow, building: Building) {
  val id = TableIds.building.next

  val values = (
    "%d\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d"
  ).format(
    id,
    building.name,
    planetRow.id,
    building.x,
    building.y,
    building.xEnd,
    building.yEnd,
    0, 0, 0, 0, 1,
    Config.buildingHp(building),
    BuildingRow.StateActive
  )
}