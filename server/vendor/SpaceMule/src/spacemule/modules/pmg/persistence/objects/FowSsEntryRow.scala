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

  def apply(ssRow: SolarSystemRow, playerRow: PlayerRow, counter: Int) =
    new FowSsEntryRow(ssRow, playerRow, counter)
}

case class FowSsEntryRow(ssRow: SolarSystemRow, playerId: Option[Int],
                         allianceId: Option[Int], counter: Int=1,
                         enemy: Boolean=false) {
  def this(ssRow: SolarSystemRow, playerRow: PlayerRow, counter: Int) = this(
    ssRow, Some(playerRow.id), None, counter)

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
    if (enemy) 0 else 1,
    if (enemy) 1 else 0
  )
}
