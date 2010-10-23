package spacemule.modules.pmg.persistence.objects

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 17, 2010
 * Time: 8:16:30 PM
 * To change this template use File | Settings | File Templates.
 */

object TileRow {
  val columns = "`planet_id`, `kind`, `x`, `y`"
}

case class TileRow(planetRow: SSObjectRow, kind: Int, x: Int, y: Int) {
  val values = "(%d, %d, %d, %d)".format(
    planetRow.id,
    kind,
    x,
    y
  )
}