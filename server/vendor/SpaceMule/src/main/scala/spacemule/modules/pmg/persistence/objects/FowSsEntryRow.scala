/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds
import spacemule.persistence.{Row, RowObject, DB}

object FowSsEntryRow extends RowObject {
  val columnsSeq = Seq(
    "id", "solar_system_id", "player_id", "alliance_id", 
    "counter", "player_planets", "player_ships", "enemy_planets"
  )
}

case class FowSsEntryRow(
  ssRow: SolarSystemRow,
  playerId: Option[Int],
  allianceId: Option[Int],
  counter: Int=1,
  empty: Boolean=true,
  enemy: Boolean=false
) extends Row {
  val companion = FowSsEntryRow

  val id = TableIds.fowSsEntries.next

  val playerPlanets = if (empty) false else ! enemy
  val enemyPlanets = if (empty) false else enemy

  val valuesSeq = Seq(
    id,
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
    if (playerPlanets) 1 else 0,
    0,
    if (enemyPlanets) 1 else 0
  )
}
