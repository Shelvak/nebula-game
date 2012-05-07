/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.config.objects

import spacemule.helpers.Converters._
import spacemule.helpers.JRuby._
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
  def extract(entries: SRArray): Seq[UnitsEntry] = {
    entries.map { rbEntryArray =>
      val entryArray = rbEntryArray.asArray
      new UnitsEntry(
        entryArray(1).toString.camelcase,
        entryArray(0).asInt,
        entryArray(2).asInt,
        entryArray(3).asDouble
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
