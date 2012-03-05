package spacemule.persistence

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 9/20/11
 * Time: 12:35 PM
 * To change this template use File | Settings | File Templates.
 */

trait RowObject {
  /**
   * Does this row type have primary key?
   *
   * Some("column") if it does.
   * None if it does not.
   **/
  val pkColumn: Option[String]

  val columnsSeq: Seq[String]
  lazy val columns: String = {
    val cols = pkColumn match {
      case Some(pk) => Seq(pk) ++ columnsSeq
      case None => columnsSeq
    }
    cols.map { "`%s`".format(_) }.mkString(", ")
  }
}