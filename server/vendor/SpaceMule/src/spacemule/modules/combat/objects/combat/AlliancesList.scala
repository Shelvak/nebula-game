package spacemule.modules.combat.objects.combat

import scala.collection.immutable
import scala.collection.mutable._
import spacemule.modules.combat.objects.NapRules
import spacemule.modules.combat.objects.Player

class AlliancesList(napRules: NapRules) {
  private val alliances = new HashMap[Int, Alliance]()
  private val players = new HashMap[Int, Set[Option[Player]]]
  private val enemyIds = new HashMap[Int, Set[Int]]()
  private val playerToAllianceId = new HashMap[Option[Player], Int]()

  def apply(allianceId: Int) = alliances(allianceId)

  /**
   * Add an alliance. Set it as enemy to others (if no nap exists).
   */
  def update(allianceId: Int, alliance: Alliance) = {
    alliances(allianceId) = alliance
    players(allianceId) = new HashSet[Option[Player]]()
    enemyIds(allianceId) = new HashSet[Int]()

    (
      alliances.keySet -- napRules.getOrElse(allianceId, immutable.Set.empty) -
        allianceId
    ).foreach { enemyAllianceId =>
      enemyIds(allianceId).add(enemyAllianceId)
      enemyIds(enemyAllianceId).add(allianceId)
    }
  }

  /**
   * Registers player that it belongs to allianceId.
   */
  def registerPlayer(allianceId: Int, player: Option[Player]) = {
    playerToAllianceId(player) = allianceId
    players(allianceId).add(player)
  }

  def allianceFor(player: Option[Player]) = this(allianceIdFor(player))
  def allianceIdFor(player: Option[Player]) = playerToAllianceId(player)
}
