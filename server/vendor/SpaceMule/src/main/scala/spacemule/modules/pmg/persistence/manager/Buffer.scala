package spacemule.modules.pmg.persistence.manager

import collection.mutable.ListBuffer
import spacemule.persistence._

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 3/3/12
 * Time: 6:10 PM
 * To change this template use File | Settings | File Templates.
 */

class Buffer(
  val tableName: String, protected val rowObject: RowObject
) extends BufferLike[Row] {
  def +=(row: Row) {
    buffer += row
  }

  protected def batchIdToOpt(batchId: String) = None
}