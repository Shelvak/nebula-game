package spacemule.modules.pmg.objects

import scala.collection.mutable.ListBuffer
import spacemule.helpers.Random
import spacemule.modules.config.objects.UnitsEntry
import spacemule.modules.pmg.classes.{UnitChance, ObjectChance}

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
   * Is this a special kind of ss object?
   */
  val special = false

  var units = ListBuffer[Unit]()

  /**
   * Provide initialization code here.
   */
  def initialize = {}

  def createOrbitUnits(entries: Iterable[UnitsEntry]): scala.Unit = {
    UnitsEntry.foreach(entries) { case (name, flank) =>
      units += Unit(name, flank)
    }
  }
}