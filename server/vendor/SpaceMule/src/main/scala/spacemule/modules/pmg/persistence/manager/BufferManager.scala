package spacemule.modules.pmg.persistence.manager

import spacemule.persistence.DB

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 3/3/12
 * Time: 6:10 PM
 * To change this template use File | Settings | File Templates.
 */

class BufferManager(readTables: String*)(buffers: Buffer*) {
  private[this] val hash =
    buffers.map { buffer => (buffer.tableName -> buffer) }.toMap
  
  def lockedTables =
    // Lock read tables in write mode because we don't want anybody to write
    // anything to them.
    readTables.map { name => (name, DB.Lock.Write) } ++
    buffers.map { buffer => (buffer.tableName, DB.Lock.Write) }

  def clear() { buffers.foreach(_.clear()) }

  // Are we currently in a transaction?
  private[this] var inTransaction = false

  def transaction[T](func: () => T): T = {
    try {
      inTransaction = true
      DB.transaction(lockedTables)(func)
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
    buffers.foreach(_.save())
  }

  def get(tableName: String) = hash(tableName)
}
