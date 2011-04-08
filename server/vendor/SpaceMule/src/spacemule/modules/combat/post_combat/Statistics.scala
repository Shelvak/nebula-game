package spacemule.modules.combat.post_combat

import scala.{collection => sc}
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

  def unwrapPlayers(map: sc.Map[Player, Int]): sc.Map[Int, Int] =
    map.map { case (player, value) => (player.id -> value) }
}

class Statistics(alliances: Alliances) {
  private val damageDealtPlayer = HashMap[Player, Int]()
  private val damageTakenPlayer = HashMap[Player, Int]()
  private val damageDealtAlliance = HashMap[Int, Int]()
  private val damageTakenAlliance = HashMap[Int, Int]()
  private val xpEarned = HashMap[Player, Int]()
  private val pointsEarned = HashMap[Player, Int]()

  alliances.eachPlayer { case (player, allianceId) =>
      damageDealtAlliance(allianceId) = 0
      damageTakenAlliance(allianceId) = 0

      player match {
        case None => ()
        case Some(player) => {
          damageDealtPlayer(player) = 0
          damageTakenPlayer(player) = 0
          xpEarned(player) = 0
          pointsEarned(player) = 0
        }
      }
  }

  def damage(source: Combatant, target: Combatant, damage: Int, sourceXp: Int,
             targetXp: Int) = {
    damageDealtAlliance(alliances.allianceIdFor(source.player)) += damage
    damageTakenAlliance(alliances.allianceIdFor(target.player)) += damage

    // NPCs do not need these stats.
    if (! source.player.isEmpty) {
      val player = source.player.get
      damageDealtPlayer(player) += damage
      xpEarned(player) += sourceXp
      pointsEarned(player) += Statistics.points(target, damage)
    }

    if (! target.player.isEmpty) {
      val player = target.player.get

      damageTakenPlayer(player) += damage
      xpEarned(player) += targetXp
    }
  }

  def asJson: Map[String, Any] = Map(
    "damage_dealt_player" -> Statistics.unwrapPlayers(damageDealtPlayer),
    "damage_taken_player" -> Statistics.unwrapPlayers(damageTakenPlayer),
    "damage_dealt_alliance" -> damageDealtAlliance,
    "damage_taken_alliance" -> damageTakenAlliance,
    "xp_earned" -> Statistics.unwrapPlayers(xpEarned),
    "points_earned" -> Statistics.unwrapPlayers(pointsEarned)
  )

  override def toString = """Combat statistics:

  * Damage dealt player:
    %s
  * Damage taken player:
    %s

  * Damage dealt alliance:
    %s
  * Damage taken alliance:
    %s

  * XP earned:
    %s
  * Points earned:
    %s
""".format(damageDealtPlayer, damageTakenPlayer,
           damageDealtAlliance, damageTakenAlliance,
           xpEarned, pointsEarned)
}
