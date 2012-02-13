package spacemule.modules.combat.post_combat

import scala.collection.mutable.HashMap
import spacemule.modules.config.objects.Config
import spacemule.modules.combat.objects._
import spacemule.helpers.MathFormulas

object Statistics {
  case class PlayerData(
    damageDealtPlayer: Int,
    damageTakenPlayer: Int,
    damageDealtAlliance: Int,
    damageTakenAlliance: Int,
    xpEarned: Int,
    pointsEarned: Int,
    victoryPointsEarned: Int,
    credsEarned: Int
  ) {
    lazy val toMap = Map(
      "damage_dealt_player" -> damageDealtPlayer,
      "damage_taken_player" -> damageTakenPlayer,
      "damage_dealt_alliance" -> damageDealtAlliance,
      "damage_taken_alliance" -> damageTakenAlliance,
      "xp_earned" -> xpEarned,
      "points_earned" -> pointsEarned,
      "victory_points_earned" -> victoryPointsEarned,
      "creds_earned" -> credsEarned
    )
  }

  type PlayerDataMap = Map[Option[Player], PlayerData]

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

  private[this] lazy val fairnessMultiplierFunction = 
    MathFormulas.line(Config.battleVpsMaxWeakness, 0.0, 1.0, 1.0)
  
  def fairnessMultiplier(aggressorPoints: Int, defenderPoints: Int): Double = {
    // To avoid NaNs
    if (aggressorPoints == 0) return 1.0

    val multiplier = defenderPoints.toDouble / aggressorPoints.toDouble
    if (defenderPoints >= aggressorPoints)
      multiplier
    else
      math.max(fairnessMultiplierFunction(multiplier), 0)
  }
}

class Statistics(
  alliances: Alliances,
  vpsFunction: Config.CombatVpsFormula,
  credsFunction: Config.CombatCredsFormula
) {
  private val damageDealtPlayer = HashMap[Option[Player], Int]()
  private val damageTakenPlayer = HashMap[Option[Player], Int]()
  private val damageDealtAlliance = HashMap[Long, Int]()
  private val damageTakenAlliance = HashMap[Long, Int]()
  private val xpEarned = HashMap[Option[Player], Int]()
  private val pointsEarned = HashMap[Option[Player], Int]()
  private val victoryPointsEarned = HashMap[Option[Player], Double]()
  private val credsEarned = HashMap[Option[Player], Double]()

  private val players = alliances.players.map { case (player, allianceId) =>
    damageDealtAlliance(allianceId) = 0
    damageTakenAlliance(allianceId) = 0

    damageDealtPlayer(player) = 0
    damageTakenPlayer(player) = 0
    xpEarned(player) = 0
    pointsEarned(player) = 0
    victoryPointsEarned(player) = 0
    credsEarned(player) = 0

    (player, allianceId)
  }
  
  private val pointsCache = HashMap.empty[Player, Int]
  
  private def pointsForFairnessMultiplier(player: Player) = {
    if (pointsCache.contains(player)) {
      pointsCache(player)
    }
    else {
      val points = Config.fairnessPoints(player)
      pointsCache(player) = points
      points
    }
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

    (source.player, target.player) match {
      // You only get victory points for non-npc player -> non-npc player
      // damage.
      case (Some(sourcePlayer), Some(targetPlayer)) =>
        val (groundDamage, spaceDamage) =
          if (target.isGround) (damage, 0) else (0, damage)
    
        val multiplier = Statistics.fairnessMultiplier(
          pointsForFairnessMultiplier(sourcePlayer),
          pointsForFairnessMultiplier(targetPlayer)
        )
        val vps = vpsFunction(groundDamage, spaceDamage, multiplier)
        if (vps != 0) {
          victoryPointsEarned(source.player) += vps
    
          val creds = credsFunction(vps)
          if (creds != 0) credsEarned(source.player) += creds
        }
      case _ => ()
    }

    val points = target.vpsForReceivedDamage(damage)
    victoryPointsEarned(source.player) += points
  }

  /**
   * Calculate creds earned for killing particular units.
   */
  def registerKilledBy(killedBy: KilledBy) {
    killedBy.foreach { case (combatant, player) =>
      credsEarned(player) += combatant.credsForKilling
    }
  }

  def byPlayer: Statistics.PlayerDataMap = players.map {
    case (player, allianceId) =>
      val playerData = Statistics.PlayerData(
        damageDealtPlayer(player),
        damageTakenPlayer(player),
        damageDealtAlliance(allianceId),
        damageTakenAlliance(allianceId),
        xpEarned(player),
        pointsEarned(player),
        victoryPointsEarned(player).round.toInt,
        credsEarned(player).round.toInt
      )

      (player -> playerData)
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
  * Victory points earned:
    %s
  * Creds earned:
    %s
""".format(
    damageDealtPlayer, damageTakenPlayer,
    damageDealtAlliance, damageTakenAlliance,
    xpEarned, pointsEarned, victoryPointsEarned, credsEarned
  )
}
