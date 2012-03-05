package spacemule.persistence

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 9/20/11
 * Time: 12:41 PM
 * To change this template use File | Settings | File Templates.
 */

trait Row {
  val companion: RowObject
  val valuesSeq: Seq[Any]
  
  private[this] var _id = 0
  def id_=(id: Int) { _id = id }
  def id =
    if (_id == 0) throw new IllegalStateException(
      "%s does not yet have an ID!".format(this)
    )
    else _id

  def values: String = {
    if (companion.columnsSeq.size != valuesSeq.size)
      throw new IllegalArgumentException(
        ("columns sequence size (%d) must be equal to values " +
            "sequence size (%d) for %s!").format(
          companion.columnsSeq.size, valuesSeq.size, toString
        )
      )
    
    val vals = companion.pkColumn match {
      case Some(pk) => Seq(id) ++ valuesSeq
      case None => valuesSeq
    }  
    vals.map { _.toString }.mkString("\t")
  }
}