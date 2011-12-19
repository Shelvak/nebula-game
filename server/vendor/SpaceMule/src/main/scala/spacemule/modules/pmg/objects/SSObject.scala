package spacemule.modules.pmg.objects

import scala.collection.mutable.ListBuffer
import spacemule.helpers.Random
import spacemule.modules.pmg.classes.{UnitChance, ObjectChance}
import spacemule.modules.config.objects.{ResourcesEntry, SsConfig, UnitsEntry}

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
  val units = ListBuffer[Troop]()
  
  /**
   * Units in orbit.
   */
  val orbitUnits = ListBuffer[Troop]()

  /**
   * Wreckage in orbit.
   */
  var wreckage: Option[ResourcesEntry] = None

  /**
   * Provide initialization code here.
   */
  def initialize {}

  def createUnits(entries: Iterable[UnitsEntry]) {
    createUnits(entries, units)
  }
  
  def createOrbitUnits(entries: Iterable[UnitsEntry]) {
    createUnits(entries, orbitUnits)
  }
  
  private def createUnits(
    entries: Iterable[UnitsEntry], target: ListBuffer[Troop]
  ) {
    entries.foreach { entry =>
      target ++= entry.createTroops()
    }
  }
}