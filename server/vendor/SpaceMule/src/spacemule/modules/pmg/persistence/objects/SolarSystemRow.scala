package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.pmg.objects.{Zone, Galaxy}
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 17, 2010
 * Time: 3:44:29 PM
 * To change this template use File | Settings | File Templates.
 */

object SolarSystemRow {
  val columns = "`id`, `type`, `galaxy_id`, `x`, `y`"
}

case class SolarSystemRow(galaxy: Galaxy, zone: Zone, ssCoord: Coords,
             solarSystem: objects.SolarSystem) {
  val id = TableIds.solarSystem.next
  val values = "(%d, '%s', %d, %d, %d)".format(
    id,
    solarSystem.getClass.getSimpleName,
    galaxy.id,
    zone.x * zone.diameter + ssCoord.x,
    zone.y * zone.diameter + ssCoord.y
  )
}