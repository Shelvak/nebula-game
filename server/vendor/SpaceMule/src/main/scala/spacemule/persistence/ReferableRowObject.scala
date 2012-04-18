package spacemule.persistence

/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 3/27/12
 * Time: 6:21 PM
 * To change this template use File | Settings | File Templates.
 */

trait ReferableRowObject extends RowObject {
  val pkColumn: String
}
