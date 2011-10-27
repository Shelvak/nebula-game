package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.pmg.objects.planet.Building
import spacemule.persistence.{RowObject, Row}

object BuildingRow extends RowObject {
  val columnsSeq = List("id", "type", "planet_id", "x", "y", "x_end", "y_end",
    "armor_mod", "construction_mod", "energy_mod", "constructor_mod", "level",
    "state", "flags")

  val StateActive = 1

  val FlagWithoutPoints = Integer.parseInt("00000010", 2)
}

case class BuildingRow(planetRow: SSObjectRow, building: Building) extends Row {
  val companion = BuildingRow

  val id = TableIds.building.next

  val valuesSeq = List(
    id,
    building.name,
    planetRow.id,
    building.x,
    building.y,
    building.xEnd,
    building.yEnd,
    0, 0, 0, 0, building.level,
    BuildingRow.StateActive,
    BuildingRow.FlagWithoutPoints
  )
}