package spacemule.modules.pmg.persistence.manager

import collection.mutable.ListBuffer
import spacemule.persistence.{Row, DB, RowObject}

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 3/3/12
 * Time: 6:10 PM
 * To change this template use File | Settings | File Templates.
 */

class Buffer(val tableName: String, rowObject: RowObject) {
  private[this] val buffer = ListBuffer[String]()

  private[this] var id = 0
  private[this] var idInitialized = false

  private[this] def nextId() = {
    if (! idInitialized) {
      id = DB.getOne[Int]("SELECT MAX(id) FROM `%s`".format(tableName)) match {
        case Some(id: Int) => id
        case None => 0
      }
      idInitialized = true
    }

    id += 1

    id
  }

  def clear() {
    buffer.clear()
    idInitialized = false
  }
  def save() {
    if (buffer.isEmpty) return

    DB.loadInFile(tableName, rowObject.columns, buffer)
  }

  def +=(row: Row) {
    if (row.companion.pkColumn.isDefined)
      row.id = nextId()
    buffer += row.values
  }
}