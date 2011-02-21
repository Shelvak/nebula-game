package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.solar_systems.Wormhole
import spacemule.modules.pmg.objects.{Galaxy, SolarSystem}
import spacemule.persistence.DB

object SolarSystemRow {
  val columns = "`id`, `galaxy_id`, `x`, `y`, `wormhole`"
}

case class SolarSystemRow(val galaxyId: Int, val solarSystem: SolarSystem,
coords: Option[Coords]) {
  def this(galaxy: Galaxy, solarSystem: SolarSystem, coords: Coords) = 
    this(galaxy.id, solarSystem, Some(coords))

  val id = TableIds.solarSystem.next
  val values = "%d\t%d\t%s\t%s\t%d".format(
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
    solarSystem match {
      case wh: Wormhole => 1
      case _ => 0
    }
  )
}