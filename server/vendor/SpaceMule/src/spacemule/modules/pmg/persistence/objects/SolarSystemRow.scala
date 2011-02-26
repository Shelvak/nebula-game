package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.pmg.objects.Galaxy
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects

object SolarSystemRow {
  val columns = "`id`, `galaxy_id`, `x`, `y`"
}

case class SolarSystemRow(galaxy: Galaxy, coords: Coords) {
  val id = TableIds.solarSystem.next
  val values = "%d\t%d\t%d\t%d".format(
    id,
    galaxy.id,
    coords.x,
    coords.y
  )
}