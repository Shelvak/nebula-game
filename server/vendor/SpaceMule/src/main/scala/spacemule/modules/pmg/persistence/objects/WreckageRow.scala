package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.objects.Location
import spacemule.persistence.{RowObject, Row, DB}
import spacemule.modules.config.objects.ResourcesEntry

object WreckageRow extends RowObject {
  val pkColumn = Some("id")
  val columnsSeq = Seq(
    "location_galaxy_id", "location_solar_system_id",
    "location_x", "location_y",
    "metal", "energy", "zetium"
  )
}

case class WreckageRow(
  location: Location, entry: ResourcesEntry
) extends Row {
  val companion = WreckageRow

  val valuesSeq = Seq(
    if (location.kind == Location.Galaxy) location.id else DB.loadInFileNull,
    if (location.kind == Location.SolarSystem)
      location.id else DB.loadInFileNull,
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