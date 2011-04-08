package spacemule.modules.combat.post_combat

import scala.collection.mutable.HashMap
import spacemule.helpers.Converters._
import spacemule.modules.combat.objects._

protected class Entry {
  val alive = HashMap[String, Int]()
  val dead = HashMap[String, Int]()

  /**
   * Increase alive/dead counter for combatant.
   */
  def +=(combatant: Combatant) = {
    val map = if (combatant.isAlive) alive else dead
    map ||= (combatant.rubyName, 0)
    map(combatant.rubyName) += 1
  }

  def asJson = Map(
    "alive" -> alive,
    "dead" -> dead
  )
}

/**
 * Yours, alliance, NAP, enemy alive/dead calculator.
 */
class YANECalculator(alliances: Alliances, combatants: Iterable[Combatant]) {
  private val playerEntries = HashMap[Int, Entry]()
  private val allianceEntries = HashMap[Int, Entry]()
  private val enemyEntries = HashMap[Int, Entry]()
  private val napEntries = HashMap[Int, Entry]()

  // Do not populate maps until we need them.
  lazy val initialized = {
    def add(map: HashMap[Int, Entry], player: Player, combatant: Combatant) = {
      map ||= (player.id, new Entry())
      map(player.id) += combatant
    }

    def addAll(map: HashMap[Int, Entry], players: Iterable[Player],
            combatant: Combatant) =
      players.foreach { player => add(map, player, combatant) }

    combatants.groupBy { _.player }.foreach { case (owner, combatants) =>
        val alliancePlayers = alliances.allianceFor(owner).players.
          filter { owner != _ }.flatten
        val enemyPlayers = alliances.enemiesFor(owner).map {
          _.players
        }.flatten.flatten
        val napPlayers = alliances.napsFor(owner).map {
          _.players
        }.flatten.flatten

        combatants.foreach { combatant =>
          // NPCs don't need these stats.
          if (! owner.isEmpty) add(playerEntries, owner.get, combatant)
          addAll(allianceEntries, alliancePlayers, combatant)
          addAll(enemyEntries, enemyPlayers, combatant)
          addAll(napEntries, napPlayers, combatant)
        }
    }

    true
  }

  def asJson = {
    initialized
    Map(
      "yours" -> playerEntries.mapValues { _.asJson },
      "alliance" -> allianceEntries.mapValues { _.asJson },
      "enemy" -> enemyEntries.mapValues { _.asJson },
      "nap" -> napEntries.mapValues { _.asJson }
    )
  }
}
