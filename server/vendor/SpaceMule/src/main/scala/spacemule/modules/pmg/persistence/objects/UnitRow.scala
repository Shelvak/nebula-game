package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.pmg.objects.{Location, Troop, Galaxy}
import spacemule.modules.config.objects.Config
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
    "id", "galaxy_id", "type", "level", "location_id",
    "location_type", "location_x", "location_y", "flank", "hp_percentage"
  )
}

case class UnitRow(galaxyId: Int, location: Location, troop: Troop)
extends Row {
  val companion = UnitRow

  val id = TableIds.unit.next

  val valuesSeq = Seq(
    id,
    galaxyId,
    troop.name,
    1,
    location.id,
    location.kind.id,
    location.x match {
      case Some(x: Int) => x.toString
      case None => DB.loadInFileNull
    },
    location.y match {
      case Some(y: Int) => y.toString
      case None => DB.loadInFileNull
    },
    troop.flank,
    troop.hpPercentage
  )
}