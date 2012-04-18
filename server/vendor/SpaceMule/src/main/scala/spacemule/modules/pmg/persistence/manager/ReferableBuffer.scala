package spacemule.modules.pmg.persistence.manager

import collection.mutable.ListBuffer
import spacemule.persistence._

/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 3/27/12
 * Time: 6:33 PM
 * To change this template use File | Settings | File Templates.
 */

class ReferableBuffer(
  override val tableName: String, protected val rowObject: ReferableRowObject
) extends BufferLike[ReferableRow] {
  @EnhanceStrings
  override def save(batchId: String) {
    super.save(batchId)

    val pk = rowObject.pkColumn
    val ids = DB.getCol[Int](
      "SELECT `#pk` FROM `#tableName` WHERE `batch_id`='#batchId'"
    )
    if (buffer.size != ids.size)
      throw new IllegalStateException(
        "Cannot find all IDs (#ids.size found) for entries in buffer (" +
        "#buffer.size found) for table #tableName!"
      )

    val zipped = buffer.view.zip(ids).force
    zipped.foreach { case (row, id) => row.id = id }
  }

  def +=(row: ReferableRow) {
    buffer += row
  }

  protected def batchIdToOpt(batchId: String) = Some(batchId)
}
