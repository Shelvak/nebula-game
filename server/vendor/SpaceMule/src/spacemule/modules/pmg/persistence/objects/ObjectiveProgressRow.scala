/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds

object ObjectiveProgressRow {
  val columns = "`id`, `objective_id`, `player_id`"
}

case class ObjectiveProgressRow(objectiveId: Int, playerId: Int) {
  val id = TableIds.objectiveProgresses.next
  val values = "%d\t%d\t%d\t0".format(
    id, objectiveId, playerId
  )
}