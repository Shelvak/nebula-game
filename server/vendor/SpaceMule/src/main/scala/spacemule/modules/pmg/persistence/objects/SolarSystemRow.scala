package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.{Galaxy, SolarSystem}
import spacemule.persistence.{Row, RowObject, DB}
import spacemule.modules.pmg.persistence.manager.Buffer

object SolarSystemRow extends RowObject {
  val pkColumn = Some("id")
  val columnsSeq = Seq("galaxy_id", "x", "y", "kind", "player_id")
}

case class SolarSystemRow(
  val galaxyId: Int, val solarSystem: SolarSystem,
  coords: Option[Coords], playerRow: Option[PlayerRow]
) extends Row {
  val companion = SolarSystemRow

  def x = coords.get.x
  def y = coords.get.y
  def kind = solarSystem.kind.id

  val valuesSeq = Seq(
    galaxyId,
    coords match {
      case Some(coords) => coords.x.toString
      case None => DB.loadInFileNull
    },
    coords match {
      case Some(coords) => coords.y.toString
      case None => DB.loadInFileNull
    },
    solarSystem.kind.id,
    playerRow match {
      case Some(playerRow) => playerRow.id.toString
      case None => DB.loadInFileNull
    }
  )
}