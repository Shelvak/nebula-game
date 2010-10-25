package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.pmg.objects.Galaxy
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

case class SolarSystemRow(galaxy: Galaxy, coords: Coords,
             solarSystem: objects.SolarSystem) {
  val id = TableIds.solarSystem.next
  val values = "%d\t%s\t%d\t%d\t%d".format(
    id,
    solarSystem.getClass.getSimpleName,
    galaxy.id,
    coords.x,
    coords.y
  )
}