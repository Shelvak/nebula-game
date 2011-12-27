package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.solar_systems.Homeworld
import spacemule.modules.pmg.objects.{Galaxy, SolarSystem}
import spacemule.persistence.{Row, RowObject, DB}

object SolarSystemRow extends RowObject {
  val columnsSeq = Seq("id", "galaxy_id", "x", "y", "kind", "player_id")
}

case class SolarSystemRow(
  val galaxyId: Int, val solarSystem: SolarSystem, coords: Option[Coords],
  playerRow: Option[PlayerRow]
) extends Row {
  val companion = SolarSystemRow

  val id = TableIds.solarSystem.next
  val valuesSeq = Seq(
    id,
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