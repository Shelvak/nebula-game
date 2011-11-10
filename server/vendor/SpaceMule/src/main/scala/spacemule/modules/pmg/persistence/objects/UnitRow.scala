package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.pmg.objects.{Location, Troop, Galaxy}
import spacemule.modules.config.objects.Config
import spacemule.persistence.DB

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 17, 2010
 * Time: 6:14:35 PM
 * To change this template use File | Settings | File Templates.
 */

object UnitRow {
  val columns = "`id`, `galaxy_id`, `type`, `level`, " +
  "`location_id`, `location_type`, `location_x`, `location_y`, `flank`"
}

case class UnitRow(galaxyId: Int, location: Location, unit: Troop) {
  val id = TableIds.unit.next

  val values = "%d\t%d\t%s\t%d\t%d\t%d\t%s\t%s\t%d".format(
    id,
    galaxyId,
    unit.name,
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
    unit.flank
  )
}