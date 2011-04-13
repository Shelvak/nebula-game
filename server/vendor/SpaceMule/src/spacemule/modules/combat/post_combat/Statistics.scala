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
}

class Statistics(alliances: Alliances) {
  private val damageDealtPlayer = HashMap[Option[Player], Int]()
  private val damageTakenPlayer = HashMap[Option[Player], Int]()
  private val damageDealtAlliance = HashMap[Int, Int]()
  private val damageTakenAlliance = HashMap[Int, Int]()
  private val xpEarned = HashMap[Option[Player], Int]()
  private val pointsEarned = HashMap[Option[Player], Int]()

  private val players = alliances.players.map { case (player, allianceId) =>
      damageDealtAlliance(allianceId) = 0
      damageTakenAlliance(allianceId) = 0

      damageDealtPlayer(player) = 0
      damageTakenPlayer(player) = 0
      xpEarned(player) = 0
      pointsEarned(player) = 0

      (player, allianceId)
  }

  def damage(source: Combatant, target: Combatant, damage: Int, sourceXp: Int,
             targetXp: Int) = {
    damageDealtAlliance(alliances.allianceIdFor(source.player)) += damage
    damageTakenAlliance(alliances.allianceIdFor(target.player)) += damage

    damageDealtPlayer(source.player) += damage
    damageTakenPlayer(target.player) += damage

    xpEarned(source.player) += sourceXp
    xpEarned(target.player) += targetXp
    pointsEarned(source.player) += Statistics.points(target, damage)
  }

  lazy val asJson: Map[Int, Map[String, Any]] = players.map {
    case (player, allianceId) => {
      val playerId = player match {
        case None => 0
        case Some(player) => player.id
      }
        
      val map = Map(
        "damage_dealt_player" -> damageDealtPlayer(player),
        "damage_taken_player" -> damageTakenPlayer(player),
        "damage_dealt_alliance" -> damageDealtAlliance(allianceId),
        "damage_taken_alliance" -> damageTakenAlliance(allianceId),
        "xp_earned" -> xpEarned(player),
        "points_earned" -> pointsEarned(player)
      )

      (playerId -> map)
    }
  }.toMap

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
