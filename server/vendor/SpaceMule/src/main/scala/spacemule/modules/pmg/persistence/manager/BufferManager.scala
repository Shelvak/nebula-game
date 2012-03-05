package spacemule.modules.pmg.persistence.manager

import spacemule.persistence.DB

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 3/3/12
 * Time: 6:10 PM
 * To change this template use File | Settings | File Templates.
 */

class BufferManager(buffers: Buffer*) {
  private[this] val hash =
    buffers.map { buffer => (buffer.tableName -> buffer) }.toMap

  def clear() { buffers.foreach(_.clear()) }

  def save() {
    DB.transaction { () =>
      buffers.foreach(_.save())
    }
  }

  def get(tableName: String) = hash(tableName)
}
