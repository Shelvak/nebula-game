package spacemule.persistence

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 9/20/11
 * Time: 12:35 PM
 * To change this template use File | Settings | File Templates.
 */

trait RowObject {
  val columnsSeq: Seq[String]
  lazy val columns: String = columnsSeq.map { "`%s`".format(_) }.mkString(", ")
}