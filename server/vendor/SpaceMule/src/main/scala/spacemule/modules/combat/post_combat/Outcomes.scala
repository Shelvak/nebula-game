package spacemule.modules.combat.post_combat

import scala.collection.immutable.HashMap
import spacemule.modules.combat.objects.Alliances
import spacemule.modules.combat.objects.Player
import spacemule.modules.combat.Combat

object Outcomes {
  type PlayerMap = Map[Option[Player], Combat.Outcome.Value]
}

class Outcomes(alliances: Alliances) {
  private var _outcomes = HashMap[Option[Player], Combat.Outcome.Value]()

  lazy private val initialized =
    alliances.players.foreach { case(player, allianceId) =>
      val outcome =
        if (alliances.isAlive(player))
          if (alliances.hasAliveEnemies(allianceId)) Combat.Outcome.Tie
          else Combat.Outcome.Win
        else Combat.Outcome.Lose
      this(player) = outcome
    }

  def update(player: Option[Player], outcome: Combat.Outcome.Value) =
    _outcomes = _outcomes + (player -> outcome)

  override def toString = {initialized; _outcomes.toString}
  
  /**
   * Check if this combat was a both-way tie.
   */
  def isTie = {initialized; _outcomes.filterNot { 
    case (player, outcome) => outcome == Combat.Outcome.Tie
  }.isEmpty}

  def byPlayer: Outcomes.PlayerMap = {initialized; _outcomes}
}
