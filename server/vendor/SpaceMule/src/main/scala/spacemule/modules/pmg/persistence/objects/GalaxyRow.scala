package spacemule.modules.pmg.persistence.objects

import spacemule.persistence.{ReferableRowObject, ReferableRow}


/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 3/28/12
 * Time: 1:16 PM
 * To change this template use File | Settings | File Templates.
 */

object GalaxyRow extends ReferableRowObject {
  val columnsSeq = Seq.empty
  val pkColumn = "id"
}

class GalaxyRow extends ReferableRow {
  def this(id: Int) { this(); _id = id }

  val companion = GalaxyRow
  protected[this] def valuesImpl = Seq.empty
}
