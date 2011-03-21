package spacemule.modules.combat

import scala.collection.mutable.HashMap
import spacemule.modules.combat.objects.Alliances
import spacemule.modules.combat.objects.Combatant
import spacemule.modules.combat.objects.Player
import spacemule.modules.combat.objects.Resources

object Statistics {
  def xp(target: Combatant, damage: Int) = {
    val attackerXp = damage
    val targetXp = 2 * damage
    (attackerXp, targetXp)
  }

  def points(target: Combatant, damage: Int): Int = {
    if (damage == 0) return 0

    val percentage = damage.toDouble / target.hitPoints
    Resources.totalVolume(target, percentage)
  }
}

class Statistics(alliances: Alliances) {
  private type OPlayer = Option[Player]

  private val damageDealtPlayer = HashMap[OPlayer, Int]()
  private val damageTakenPlayer = HashMap[OPlayer, Int]()
  private val damageDealtAlliance = HashMap[Int, Int]()
  private val damageTakenAlliance = HashMap[Int, Int]()
  private val xpEarned = HashMap[OPlayer, Int]()
  private val pointsEarned = HashMap[OPlayer, Int]()

  alliances.eachPlayer { case (player, allianceId) =>
      damageDealtPlayer(player) = 0
      damageTakenPlayer(player) = 0
      damageDealtAlliance(allianceId) = 0
      damageTakenAlliance(allianceId) = 0
      xpEarned(player) = 0
      pointsEarned(player) = 0
  }

  def damage(source: Combatant, target: Combatant, damage: Int, sourceXp: Int,
             targetXp: Int) = {
    damageDealtPlayer(source.player) += damage
    damageTakenPlayer(target.player) += damage
    damageDealtAlliance(alliances.allianceId(source.player)) += damage
    damageTakenAlliance(alliances.allianceId(target.player)) += damage
    xpEarned(source.player) += sourceXp
    xpEarned(target.player) += targetXp
    pointsEarned(source.player) += Statistics.points(target, damage)
  }
}
