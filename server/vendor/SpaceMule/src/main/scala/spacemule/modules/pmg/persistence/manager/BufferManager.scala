package spacemule.modules.pmg.persistence.manager

import spacemule.persistence.{Row, DB}


/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 3/3/12
 * Time: 6:10 PM
 * To change this template use File | Settings | File Templates.
 */

class BufferManager(buffers: BufferLike[Row]*) {
  def clear() { buffers.foreach(_.clear()) }

  // Are we currently in a transaction?
  private[this] var inTransaction = false

  def transaction[T](func: () => T): T = {
    try {
      inTransaction = true
      DB.transaction(func)
    }
    finally {
      inTransaction = false
    }
  }

  def save() {
    if (! inTransaction)
      throw new IllegalStateException(
        "You should not save buffers while not in transaction!"
      )

    val batchId = DB.batchId
    buffers.foreach { _.save(batchId) }
  }
}
