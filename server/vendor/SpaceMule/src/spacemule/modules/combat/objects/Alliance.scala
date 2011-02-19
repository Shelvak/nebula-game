/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.combat.objects

import scala.collection.mutable
import spacemule.modules.combat.objects.combat.AlliancesList
import spacemule.modules.combat.objects
import spacemule.modules.combat.objects.combat.Flank

object Alliance {
  /**
   * Group players to map where keys are alliance ids and values are sets of
   * players belonging to that alliance.
   *
   * Players that do not belong to any alliance get negative alliance ids
   * starting from -1.
   */
  def group(players: Set[Option[Player]]): Map[Int, Set[Option[Player]]] = {
    val grouped = mutable.HashMap[Int, mutable.Set[Option[Player]]]()
    var notAlliedId = 0

    players.foreach { player =>
      val allianceId = (player match {
        case Some(player) => player.allianceId
        case None => None
      }) match {
        case Some(id) => id
        case None => {
            notAlliedId -= 1
            notAlliedId
        }
      }

      if (! grouped.contains(allianceId)) {
        grouped(allianceId) = new mutable.HashSet[Option[Player]]()
      }

      grouped(allianceId).add(player)
    }

    // Return immutable map.
    grouped.mapValues { set => set.toSet }.toMap
  }
}