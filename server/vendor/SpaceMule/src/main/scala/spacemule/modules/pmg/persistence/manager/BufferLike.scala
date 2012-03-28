package spacemule.modules.pmg.persistence.manager

import collection.mutable.ListBuffer
import spacemule.persistence.{DB, RowObject, Row}

/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 3/28/12
 * Time: 1:06 PM
 * To change this template use File | Settings | File Templates.
 */

trait BufferLike[+R <: Row] {
  val tableName: String
  protected[this] val rowObject: RowObject

  protected[this] val buffer = ListBuffer.empty[R]

  def clear() {
    buffer.clear()
  }

  @EnhanceStrings
  def save(batchId: String) {
    if (buffer.isEmpty) return

    DB.loadInFile(
      tableName, rowObject.columns, buffer.map(_.values),
      batchIdToOpt(batchId)
    )
  }

  protected def batchIdToOpt(batchId: String) : Option[String]
}
