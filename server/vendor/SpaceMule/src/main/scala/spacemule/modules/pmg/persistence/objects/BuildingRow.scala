package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.objects.planet.Building
import spacemule.persistence.{RowObject, Row, ReferableRowObject}

object BuildingRow extends RowObject with ReferableRowObject {
  val pkColumn = "id"
  val columnsSeq = List("type", "planet_id", "x", "y", "x_end", "y_end",
    "armor_mod", "construction_mod", "energy_mod", "constructor_mod", "level",
    "state", "flags")

  val StateActive = 1

  val FlagWithoutPoints = Integer.parseInt("00000010", 2)
}

case class BuildingRow(planetRow: SSObjectRow, building: Building)
extends Row with LocationRow {
  val companion = BuildingRow

  lazy val valuesSeq = List(
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