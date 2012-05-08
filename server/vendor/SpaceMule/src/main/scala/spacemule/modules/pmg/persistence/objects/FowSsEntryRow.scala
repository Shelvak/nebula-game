/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.persistence.objects

import spacemule.persistence._


object FowSsEntryRow extends ReferableRowObject {
  sealed abstract class Owner
  object Owner {
    case class Player(row: PlayerRow) extends Owner
    case class Alliance(id: Int) extends Owner
  }

  val pkColumn = "id"
  val columnsSeq = Seq(
    "solar_system_id", "player_id", "alliance_id",
    "counter", "player_planets", "player_ships", "enemy_planets"
  )
}

case class FowSsEntryRow(
  ssRow: SolarSystemRow,
  owner: FowSsEntryRow.Owner,
  counter: Int=1,
  empty: Boolean=true,
  enemy: Boolean=false
) extends ReferableRow {
  val companion = FowSsEntryRow

  val playerPlanets = if (empty) false else ! enemy
  val enemyPlanets = if (empty) false else enemy

  // Used in Ruby.
  def playerId = owner match {
    case FowSsEntryRow.Owner.Player(row) => row.id
    case FowSsEntryRow.Owner.Alliance(_) => null
  }
  // Used in Ruby.
  def allianceId = owner match {
    case FowSsEntryRow.Owner.Player(_) => null
    case FowSsEntryRow.Owner.Alliance(aid) => aid
  }

  protected[this] def valuesImpl = Seq(
    ssRow.id,
    owner match {
      case FowSsEntryRow.Owner.Player(row) => row.id.toString
      case FowSsEntryRow.Owner.Alliance(_) => DB.loadInFileNull
    },
    owner match {
      case FowSsEntryRow.Owner.Player(_) => DB.loadInFileNull
      case FowSsEntryRow.Owner.Alliance(aid) => aid.toString
    },
    counter,
    if (playerPlanets) 1 else 0,
    0,
    if (enemyPlanets) 1 else 0
  )
}
