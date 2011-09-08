/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds

object QuestProgressRow {
  val columns = "`id`, `quest_id`, `player_id`, `status`"

  // Quest is just started by +Player+.
  val StatusStarted = 0
  // Quest has been completed by +Player+ but the reward is not taken yet.
  // However children quests can be done by the player.
  val StatusCompleted = 1
  // Quest has been completed and the reward was taken.
  val StatusRewardTaken = 2
}

case class QuestProgressRow(questId: Int, playerId: Int) {
  val id = TableIds.questProgresses.next
  val values = "%d\t%d\t%d\t0".format(
    id, questId, playerId
  )
}
