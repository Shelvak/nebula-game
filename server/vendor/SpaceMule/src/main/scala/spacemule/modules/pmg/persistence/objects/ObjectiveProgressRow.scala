/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.persistence.objects

import spacemule.persistence.{Row, RowObject}

object ObjectiveProgressRow extends RowObject {
  val columnsSeq = List("objective_id", "player_id")
}

case class ObjectiveProgressRow(objectiveId: Int, player: PlayerRow)
extends Row {
  val companion = ObjectiveProgressRow

  lazy val valuesSeq = List(
    objectiveId, player.id
  )
}