package spacemule.modules.combat.post_combat

import scala.collection.mutable.HashMap
import spacemule.helpers.Converters._
import spacemule.modules.combat.objects._

protected object Entry {
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

  def asJson: Map[String, collection.Map[String, Int]] = Map(
    "alive" -> alive,
    "dead" -> dead
  )
}

/**
 * Yours, alliance, NAP, enemy alive/dead calculator.
 */
class YANECalculator(alliances: Alliances, combatants: Iterable[Combatant],
                     loadedTroops: Map[Int, Seq[Troop]]) {
  private val playerEntries = HashMap[Int, Entry]()
  private val allianceEntries = HashMap[Int, Entry]()
  private val enemyEntries = HashMap[Int, Entry]()
  private val napEntries = HashMap[Int, Entry]()

  /**
   * Map[playerId: Int -> Map[String, Entry]]
   */
  lazy val asJson = {
    def add(map: HashMap[Int, Entry], player: Player, combatant: Combatant) = {
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

    def addAll(map: HashMap[Int, Entry], players: Iterable[Player],
            combatant: Combatant) =
      players.foreach { player => add(map, player, combatant) }

    val playerIds = combatants.groupBy { _.player }.map {
      case (owner, combatants) =>
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

        owner
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
