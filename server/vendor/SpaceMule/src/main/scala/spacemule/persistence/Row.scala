package spacemule.persistence

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 9/20/11
 * Time: 12:41 PM
 * To change this template use File | Settings | File Templates.
 */

trait Row {
  val valuesSeq: Seq[Any]
  lazy val values: String = valuesSeq.map { _.toString }.mkString("\t")
}