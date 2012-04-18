package spacemule.persistence

/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 3/27/12
 * Time: 6:19 PM
 * To change this template use File | Settings | File Templates.
 */

trait ReferableRow extends Row {
  val companion: ReferableRowObject

  protected[this] var _id = 0
  def id_=(id: Int) { _id = id }
  def id =
    if (_id == 0) throw new IllegalStateException(
      "%s does not yet have an ID!".format(this)
    )
    else _id
}
