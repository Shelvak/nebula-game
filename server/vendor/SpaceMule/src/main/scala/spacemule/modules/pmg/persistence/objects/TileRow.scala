package spacemule.modules.pmg.persistence.objects

import spacemule.persistence.{Row, RowObject}


/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 17, 2010
 * Time: 8:16:30 PM
 * To change this template use File | Settings | File Templates.
 */

object TileRow extends RowObject {
  val pkColumn = None
  val columnsSeq = List("planet_id", "kind", "x", "y")
}

case class TileRow(planetRow: SSObjectRow, kind: Int, x: Int, y: Int) 
  extends Row 
{
  val companion = TileRow
  lazy val valuesSeq = List(
    planetRow.id,
    kind,
    x,
    y
  )
}