package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.SolarSystem
import spacemule.persistence._

object SolarSystemRow extends ReferableRowObject {
  val pkColumn = "id"
  val columnsSeq = Seq("galaxy_id", "x", "y", "kind")
}

case class SolarSystemRow(
  val galaxyId: Int, val solarSystem: SolarSystem, coords: Option[Coords]
) extends LocationRow {
  val companion = SolarSystemRow

  def x = coords.get.x
  def y = coords.get.y
  def kind = solarSystem.kind.id

  protected[this] def valuesImpl = Seq(
    galaxyId,
    coords match {
      case Some(coords) => coords.x.toString
      case None => DB.loadInFileNull
    },
    coords match {
      case Some(coords) => coords.y.toString
      case None => DB.loadInFileNull
    },
    kind
  )
}