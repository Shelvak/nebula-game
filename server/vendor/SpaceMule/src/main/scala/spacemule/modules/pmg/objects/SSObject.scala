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
   * Ground units.
   */
  var units = ListBuffer[Troop]()
  
  /**
   * Units in orbit.
   */
  var orbitUnits = ListBuffer[Troop]()

  /**
   * Provide initialization code here.
   */
  def initialize = {}

  def createUnits(entries: Iterable[UnitsEntry]): scala.Unit = 
    createUnits(entries, units)
  
  def createOrbitUnits(entries: Iterable[UnitsEntry]): scala.Unit =
    createUnits(entries, orbitUnits)
  
  private def createUnits(
    entries: Iterable[UnitsEntry], target: ListBuffer[Troop]
  ): scala.Unit = {
    UnitsEntry.foreach(entries) { case (name, flank) =>
      target += Troop(name, flank)
    }
  }
}