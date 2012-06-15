package spacemule.modules.pmg.persistence.manager

import spacemule.persistence.{Row, DB}
import spacemule.logging.Log


/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 3/3/12
 * Time: 6:10 PM
 * To change this template use File | Settings | File Templates.
 */

class BufferManager(buffers: BufferLike[Row]*) {
  def clear() { buffers.foreach(_.clear()) }

  def save() {
    val batchId = DB.batchId
    buffers.foreach { buffer =>
      Log.block(
        "Saving buffer "+buffer.tableName+" with "+buffer.size+" entries",
        level=Log.Debug
      ) { () =>
        buffer.save(batchId)
      }
    }
  }
}
