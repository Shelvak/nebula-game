package spacemule.modules.combat

import scala.collection.immutable.HashMap
import spacemule.modules.combat.objects.Player

class Outcomes {
  private var _outcomes = HashMap[Option[Player], Combat.Outcome.Value]()

  def update(player: Option[Player], outcome: Combat.Outcome.Value) =
    _outcomes = _outcomes + (player -> outcome)

  override def toString = _outcomes.toString

  def asJson = _outcomes.map { case (player, outcome) =>
    (Player.idForJson(player) -> outcome.id)
  }
}
