/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds
import spacemule.persistence.DB

object FowSsEntryRow {
  val columns = "`id`, `solar_system_id`, `player_id`, `alliance_id`, " +
    "`counter`, `player_planets`, `enemy_planets`, `player_ships`"
}

case class FowSsEntryRow(ssRow: SolarSystemRow, playerId: Option[Int],
                         allianceId: Option[Int], counter: Int=1,
                         empty: Boolean=true, enemy: Boolean=false) {
  val values = "%d\t%d\t%s\t%s\t%d\t%d\t%d\t0".format(
    TableIds.fowSsEntries.next,
    ssRow.id,
    playerId match {
      case Some(id: Int) => id.toString
      case None => DB.loadInFileNull
    },
    allianceId match {
      case Some(id: Int) => id.toString
      case None => DB.loadInFileNull
    },
    counter,
    if (empty) 0 else { if (enemy) 0 else 1 },
    if (empty) 0 else { if (enemy) 1 else 0 }
  )
}
