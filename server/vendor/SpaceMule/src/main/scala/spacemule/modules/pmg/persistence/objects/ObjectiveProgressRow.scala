/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.persistence.objects

import spacemule.persistence.{Row, RowObject}
import spacemule.modules.pmg.persistence.manager.Buffer

object ObjectiveProgressRow extends RowObject {
  val pkColumn = Some("id")
  val columnsSeq = List("objective_id", "player_id")
}

case class ObjectiveProgressRow(objectiveId: Int, playerId: Int)
  extends Row
{
  val companion = ObjectiveProgressRow

  val valuesSeq = List(
    objectiveId, playerId
  )
}