/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.config.objects

import spacemule.helpers.Converters._
import collection.mutable.ListBuffer
import spacemule.modules.pmg.objects.Troop

object UnitsEntry {
  /**
   * Extract data from dynamicly typed data store:
   *
    [
      [count, type, flank, hp_percentage],
      ...
    ]
   */
  def extract(entries: Any): Seq[UnitsEntry] = {
    entries.asInstanceOf[Seq[IndexedSeq[Any]]].map { entryArray =>
      new UnitsEntry(
        entryArray(1).asInstanceOf[String].camelcase,
        entryArray(0).asInstanceOf[Long].toInt,
        entryArray(2).asInstanceOf[Long].toInt,
        entryArray(3) match {
          case l: Long => l.toDouble
          case d: Double => d
        }
      )
    }
  }
}

class UnitsEntry(
  // Dirac, Thor, Demosis, ...
  val kind: String,
  val count: Int,
  val flank: Int,
  val hpPercentage: Double = 1.0
) {
  def createTroops() = {
    var troops = List.empty[Troop]
    count.times { () => troops = Troop(kind, flank, hpPercentage) :: troops }

    troops
  }
}
