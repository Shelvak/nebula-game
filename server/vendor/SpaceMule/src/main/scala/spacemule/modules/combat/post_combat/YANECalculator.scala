package spacemule.modules.combat.post_combat

import scala.collection.mutable.HashMap
import spacemule.helpers.Converters._
import spacemule.modules.combat.objects._
import spacemule.modules.combat.Combat

object Entry {
  type DataMap = Map[String, collection.Map[String, Int]]

  val empty = new Entry {
    override def +=(combatant: Combatant) = throw new NoSuchMethodError(
      "This set is immutable!")

    override val asJson = Map(
      "alive" -> Map[String, Int](),
      "dead" -> Map[String, Int]()
    )
  }
}

protected class Entry {
  private val alive = HashMap[String, Int]()
  private val dead = HashMap[String, Int]()

  /**
   * Increase alive/dead counter for combatant.
   */
  def +=(combatant: Combatant) = {
    val map = if (combatant.isAlive) alive else dead
    map ||= (combatant.rubyName, 0)
    map(combatant.rubyName) += 1
  }

  def asJson: Entry.DataMap = Map(
    "alive" -> alive,
    "dead" -> dead
  )
}

object YANECalculator {
  // player id -> data map
  type DataMap = Map[Long, Map[String, Entry.DataMap]]
}

/**
 * Yours, alliance, NAP, enemy alive/dead calculator.
 */
class YANECalculator(alliances: Alliances, combatants: Iterable[Combatant],
                     loadedTroops: Combat.LoadedTroops) {
  private val playerEntries = HashMap[Long, Entry]()
  private val allianceEntries = HashMap[Long, Entry]()
  private val enemyEntries = HashMap[Long, Entry]()
  private val napEntries = HashMap[Long, Entry]()

  /**
   * Map[playerId: Int -> Map[String, Entry]]
   */
  lazy val toMap: YANECalculator.DataMap = {
    def add(map: HashMap[Long, Entry], player: Player, combatant: Combatant) = {
      map ||= (player.id, new Entry())
      map(player.id) += combatant

      // Add loaded units if this transporter is dead.
      combatant match {
        case t: Troop if t.isDead => {
          loadedTroops.get(t.id) match {
            case None => ()
            case Some(troops) => troops.foreach { troop =>
                // "kill" the troop.
                troop.hp = 0
                map(player.id) += troop
            }
          }
        }
        case _ => ()
      }
    }

    def addAll(map: HashMap[Long, Entry], players: Iterable[Player],
            combatant: Combatant) =
      players.foreach { player => add(map, player, combatant) }

    val players = alliances.players.map { case (player, allianceId) => player }
    val groupedCombatants = combatants.groupBy { _.player }
    val playerIds = players.map { player =>
      val combatants = groupedCombatants.getOrElse(player, Seq.empty[Combatant])
      val alliancePlayers = alliances.allianceFor(player).players.
        filter { player != _ }.flatten
      val enemyPlayers = alliances.enemiesFor(player).map {
        _.players
      }.flatten.flatten
      val napPlayers = alliances.napsFor(player).map {
        _.players
      }.flatten.flatten

      combatants.foreach { combatant =>
        // NPCs don't need these stats.
        if (! player.isEmpty) add(playerEntries, player.get, combatant)
        addAll(allianceEntries, alliancePlayers, combatant)
        addAll(enemyEntries, enemyPlayers, combatant)
        addAll(napEntries, napPlayers, combatant)
      }

      player
    }.flatten.map { _.id }

    playerIds.map { case id =>
      val map = Map(
        "yours" -> playerEntries.getOrElse(id, Entry.empty).asJson,
        "alliance" -> allianceEntries.getOrElse(id, Entry.empty).asJson,
        "enemy" -> enemyEntries.getOrElse(id, Entry.empty).asJson,
        "nap" -> napEntries.getOrElse(id, Entry.empty).asJson
      )
      (id -> map)
    }.toMap
  }
}
