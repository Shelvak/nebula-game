package spacemule.modules.combat.objects

import scala.collection.mutable.HashMap
import spacemule.helpers.Converters._
import spacemule.helpers.{StdErrLog => L}
import spacemule.modules.combat.Combat

object Alliances {
  /**
   * Group players to map where keys are alliance ids and values are alliances.
   *
   * Players that do not belong to any alliance get negative alliance ids
   * starting from -1.
   */
  def apply(players: Set[Option[Player]], napRules: Combat.NapRules,
            combatants: Set[Combatant]): Alliances = {
    val notAllied = 0

    // Players grouped by alliance ids, not allied players are in one alliance.
    val grouped = players.groupBy { player =>
      player match {
        // Actual player
        case Some(player) => player.allianceId
        // NPC
        case None => None
      }
    }.map { case (allianceId, players) => 
        (allianceId.getOrElse(notAllied) -> players) }

    // Players grouped by alliance ids, not allied players have been given
    // negative alliance ids.
    var notAlliedId = notAllied
    val expanded = (
      (grouped - notAllied) ++ grouped(notAllied).map { player =>
        notAlliedId -= 1
        (notAlliedId -> Set(player))
      }
    )

    // Player -> alliance ID cache.
    val cache = Map() ++ expanded.map { case (allianceId, players) =>
      players.map { player => (player, allianceId) }
    }.flatten

    // Create alliance id -> alliance map wth players and combatants.
    val alliances = expanded.map { case (allianceId, players) =>
        // Filter combatants that belong to this alliance.
        val allianceCombatants = combatants.filter { c =>
          cache(c.player) == allianceId
        }
        (allianceId -> new Alliance(allianceId, players, allianceCombatants))
    }

    val allianceIds = alliances.keySet
    val enemies = alliances.map { case (allianceId, players) =>
        (allianceId -> (
            allianceIds - allianceId -- 
              napRules.getOrElse(allianceId, Set.empty)
        ).toIndexedSeq)
    }

    new Alliances(alliances, enemies, cache)
  }
}

class Alliances(map: Map[Int, Alliance],
                enemies: Map[Int, IndexedSeq[Int]],
                playerCache: Map[Option[Player], Int]) {
  /**
   * Map of who was killed by who.
   */
  private val _killedBy = new HashMap[Combatant, Option[Player]]()
  
  /**
   * Immutable map of who was killed by who.
   */
  def killedBy = _killedBy.toMap

  /**
   * Traverse initiatives. Yields combatants that should shoot in this sub-tick.
   */
  def traverseInitiatives(block: (Int, Combatant) => Unit): Unit = {
    while (true) {
      var taken = false
      map.foreach { case(allianceId, alliance) =>
          val takenSet = alliance.take
          if (! takenSet.isEmpty) taken = true

          takenSet.foreach { combatant => block(allianceId, combatant) }
      }
      
      if (! taken) return ()
    }
  }

  def eachPlayer(block: (Option[Player], Int) => Unit) = {
    map.foreach { case(allianceId, alliance) =>
        alliance.players.foreach { player => block(player, allianceId) }
    }
  }

  /**
   * Does given alliance has any enemies left?
   */
  def hasAliveEnemies(allianceId: Int) = ! aliveEnemies(allianceId).isEmpty

  /**
   * Is given player still alive? (has any troops/buildings)
   */
  def isAlive(player: Option[Player]) = allianceFor(player).isAlive(player)
  
  /**
   * Checks if this alliance is alive.
   */
  def isAlive(allianceId: Int) = map(allianceId).isAlive

  /**
   * Returns seq of alive enemy alliances.
   */
  def aliveEnemies(allianceId: Int) =
    enemies(allianceId).map { enemyAllianceId =>
      val enemyAlliance = map(enemyAllianceId)

      if (enemyAlliance.isAlive) Some(enemyAlliance)
      else None
    }.flatten

  /**
   * Returns target combatant for alliance or None if no such combatants exist.
   */
  def targetFor(allianceId: Int, gun: Gun): Option[Combatant] = {
    val enemies = aliveEnemies(allianceId)
    if (enemies.isEmpty) return None

    enemies.random.target(gun)
  }

  /**
   * Kills target and removes it from alive list.
   */
  def kill(killer: Combatant, target: Combatant) = {
    _killedBy(target) = killer.player
    val allianceId = playerCache(target.player)
    map(allianceId).kill(target)
  }

  def allianceIdFor(player: Option[Player]) = playerCache(player)

  def allianceFor(player: Option[Player]) = map(allianceIdFor(player))

  /**
   * Reset all initative lists keeping only alive units.
   */
  def reset() = L.debug("Reseting alliance initiative lists", () => 
    map.foreach { case (allianceId, alliance) => alliance.reset })
}
