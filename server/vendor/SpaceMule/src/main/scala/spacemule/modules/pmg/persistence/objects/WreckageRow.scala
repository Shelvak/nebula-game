package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.objects.Location
import spacemule.persistence.{RowObject, Row, DB}
import spacemule.modules.config.objects.ResourcesEntry

object WreckageRow extends RowObject {
  val pkColumn = Some("id")
  val columnsSeq = Seq(
    "galaxy_id",
    "location_id", "location_type", "location_x", "location_y",
    "metal", "energy", "zetium"
  )
}

case class WreckageRow(
  galaxyId: Int, location: Location, entry: ResourcesEntry
) extends Row {
  val companion = WreckageRow

  val valuesSeq = Seq(
    galaxyId,
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
    entry.metal,
    entry.energy,
    entry.zetium
  )
}