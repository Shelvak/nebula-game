package spacemule.modules.pmg.objects

import scala.collection.mutable.ListBuffer
import spacemule.modules.config.objects.{ResourcesEntry, UnitsEntry}

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 9:04:26 PM
 * To change this template use File | Settings | File Templates.
 */

/**
 * A solar system object
 */
trait SSObject {
  /**
   * type field in db
   */
  val name: String

  /**
   * Ground units.
   */
  protected[this] var _units = Seq.empty[Troop]
  def units = _units

  def createUnits(entries: Iterable[UnitsEntry]) {
    entries.foreach { entry =>
      _units = _units ++ entry.createTroops()
    }
  }
}