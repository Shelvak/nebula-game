/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.combat.objects

import spacemule.helpers.RandomArray
import spacemule.helpers.{StdErrLog => L}

object Alliances {
  /**
   * Group players to map where keys are alliance ids and values are alliances.
   *
   * Players that do not belong to any alliance get negative alliance ids
   * starting from -1.
   */
  def apply(players: Set[Option[Player]], napRules: NapRules,
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
        (allianceId -> RandomArray(
            allianceIds - allianceId -- napRules(allianceId)))
    }

    new Alliances(alliances, enemies, cache)
  }
}

class Alliances(map: Map[Int, Alliance],
                enemies: Map[Int, RandomArray[Int]],
                playerCache: Map[Option[Player], Int]) {
  /**
   * Traverse initiatives. Yields combatants that should shoot in this sub-tick.
   */
  def traverseInitiatives(block: (Int, Combatant) => Unit) = {
    map.foreach { case(allianceId, alliance) =>
        alliance.take.foreach { combatant => block(allianceId, combatant) }
    }
  }

  def eachPlayer(block: (Option[Player], Int) => Unit) = {
    map.foreach { case(allianceId, alliance) =>
        alliance.players.foreach { player => block(player, allianceId) }
    }
  }

  /**
   * Returns target combatant for alliance or None if no such combatants exist.
   */
  def targetFor(allianceId: Int, gun: Gun): Option[Combatant] = {
    val enemySet = enemies(allianceId)
    if (enemySet.size == 0) return None

    val enemyAllianceId = enemySet.random
    
    map(enemyAllianceId).target(gun.kind)
  }

  /**
   * Kills target and removes it from alive list.
   */
  def kill(target: Combatant) = {
    val allianceId = playerCache(target.player)
    map(allianceId).kill(target)
  }

  def allianceId(player: Option[Player]) = playerCache(player)

  /**
   * Reset all initative lists keeping only alive units.
   */
  def reset() = L.debug("Reseting alliance initiative lists", () => 
    map.foreach { case (allianceId, alliance) => alliance.reset })
}
