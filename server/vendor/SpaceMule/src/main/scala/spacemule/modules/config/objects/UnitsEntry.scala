/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.config.objects

import scala.{collection => sc}
import spacemule.helpers.Converters._
import jruby.JRuby._
import core.Values._
import spacemule.modules.pmg.objects.Troop

object UnitsEntry {
  type Data = sc.Seq[sc.Seq[Any]]

  /**
   * Extract data from dynamicly typed data store:
   *
    [
      [count, type, flank, hp_percentage],
      ...
    ]
   */
  def extract(entries: Data): Seq[UnitsEntry] = {
    entries.map { entryArray =>
      new UnitsEntry(
        entryArray(1).toString.camelcase,
        entryArray(0).asInstanceOf[Long],
        entryArray(2).asInstanceOf[Long],
        entryArray(3)
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
