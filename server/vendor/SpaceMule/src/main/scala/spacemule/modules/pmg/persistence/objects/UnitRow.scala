package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.objects.{Location, Troop}
import spacemule.persistence.{RowObject, Row, DB}

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 17, 2010
 * Time: 6:14:35 PM
 * To change this template use File | Settings | File Templates.
 */

object UnitRow extends RowObject {
  val columnsSeq = Seq(
    "type", "level", "flank", "hp_percentage",
    "location_galaxy_id", "location_solar_system_id", "location_ss_object_id",
    "location_unit_id", "location_building_id",
    "location_x", "location_y"
  )
}

case class UnitRow(location: Location, troop: Troop)
extends Row {
  val companion = UnitRow

  protected[this] def valuesImpl = Seq(
    troop.name,
    1,
    troop.flank,
    troop.hpPercentage,
    if (location.kind == Location.Galaxy)
      location.row.id else DB.loadInFileNull,
    if (location.kind == Location.SolarSystem)
      location.row.id else DB.loadInFileNull,
    if (location.kind == Location.SsObject)
      location.row.id else DB.loadInFileNull,
    if (location.kind == Location.Unit)
      location.row.id else DB.loadInFileNull,
    if (location.kind == Location.Building)
      location.row.id else DB.loadInFileNull,
    location.x match {
      case Some(x: Int) => x.toString
      case None => DB.loadInFileNull
    },
    location.y match {
      case Some(y: Int) => y.toString
      case None => DB.loadInFileNull
    }
  )
}