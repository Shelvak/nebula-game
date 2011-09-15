package spacemule.modules.combat.objects

import scala.util.Random
import spacemule.helpers.Converters._
import spacemule.helpers.{StdErrLog => L}
import spacemule.modules.combat.Combat

object Alliances {
  type DataMap = Map[Int, Map[String, Any]]

  /**
   * Group players to map where keys are alliance ids and values are alliances.
   *
   * Players that do not belong to any alliance get negative alliance ids
   * starting from -1.
   */
  def apply(planetOwner: Option[Player], players: Set[Option[Player]],
            allianceNames: Combat.AllianceNames,
            napRules: Combat.NapRules,
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
      (grouped - notAllied) ++ grouped.getOrElse(notAllied, Set.empty).map {
        player =>
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
        val allianceName = allianceNames.get(allianceId)
        (allianceId -> new Alliance(allianceId, allianceName,
                                    players, allianceCombatants))
    }

    val allianceIds = alliances.keySet
    val enemies = alliances.map { case (allianceId, players) =>
        (allianceId -> (
            allianceIds - allianceId -- 
              napRules.getOrElse(allianceId, Set.empty)
        ).toIndexedSeq)
    }

    new Alliances(planetOwner, alliances, enemies, cache)
  }
}

class Alliances(planetOwner: Option[Player],
                val alliancesMap: Map[Int, Alliance],
                enemies: Map[Int, IndexedSeq[Int]],
                playerCache: Map[Option[Player], Int]) {
  /**
   * Map of who was killed by who.
   */
  val killedBy = new KilledBy()

  /**
   * List of initiatives ordered in descending order.
   */
  private var initiatives = calculateInitiatives

// Seems to be a bug in scala lib: throws NPE
//  private val initiativesOrdering = Ordering.fromLessThan[Int] { _ > _ }
//
//  /**
//   * Returns list of initiatives of alliances ordered in descending order.
//   */
//  private def calculateInitiatives =
//    SortedSet.empty[Int](initiativesOrdering) ++ map.map {
//      case (allianceId, alliance) => alliance.initiatives
//    }.flatten

  private def calculateInitiatives =
    alliancesMap.map {
      case (allianceId, alliance) => alliance.initiatives
    }.flatten.toSet.toList.sortWith { _ > _ }

  /**
   * Traverse initiatives. Yields combatants that should shoot in this sub-tick.
   */
  def traverseInitiatives(block: (Int, Combatant) => Unit) = {
    // Sequence of alliance ids to shoot. Planet owner alliance always shoots 
    // first unless owner is NPC. This is also because we get None if we're
    // not fighting in the planet.
    val allianceSequence = planetOwner match {
      case None => Random.shuffle(alliancesMap.keys.toList)
      case Some(owner) => {
          val ownerAlliance = allianceIdFor(planetOwner)
          // Alliance of the planet owner should always shoot first.
          ownerAlliance ::
            Random.shuffle((alliancesMap.keySet - ownerAlliance).toList)
      }
    }

    def takeForInitiative(initiative: Int): Unit = {
      while (true) {
        var taken = false
        allianceSequence.foreach { allianceId =>
            val alliance = alliancesMap(allianceId)
            val takenSet = alliance.take(initiative)
            if (! takenSet.isEmpty) taken = true

            takenSet.foreach { combatant => block(allianceId, combatant) }
        }

        if (! taken) return ()
      }
    }

    initiatives.foreach { initiative =>
      L.debug("Taking for initiative %d".format(initiative), 
              () => takeForInitiative(initiative))
    }
  }

  /**
   * Iterable of (player, allianceId) tuples.
   */
  def players =
    alliancesMap.map { case(allianceId, alliance) =>
        alliance.players.map { player => (player, allianceId) }
    }.flatten

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
  def isAlive(allianceId: Int) = alliancesMap(allianceId).isAlive

  /**
   * Is alliance with this id a friend for player?
   */
  def isFriend(player: Option[Player], allianceId: Int) =
    allianceIdFor(player) == allianceId

  /**
   * Is alliance with this id an enemy for player?
   */
  def isEnemy(player: Option[Player], allianceId: Int) =
    enemies(allianceIdFor(player)).contains(allianceId)

  /**
   * Is alliance with this id a nap for player?
   */
  def isNap(player: Option[Player], allianceId: Int) =
    ! napsFor(player).find { _.id == allianceId }.isEmpty

  /**
   * Returns seq of alive enemy alliances.
   */
  def aliveEnemies(allianceId: Int) =
    enemies(allianceId).map { enemyAllianceId =>
      val enemyAlliance = alliancesMap(enemyAllianceId)

      if (enemyAlliance.isAlive) Some(enemyAlliance)
      else None
    }.flatten

  /**
   * Returns Alliance set which are enemies with this alliance.
   */
  def enemiesFor(allianceId: Int) = enemies(allianceId).map { alliancesMap(_) }.toSet

  /**
   * Returns Alliance set which are enemies with this player.
   */
  def enemiesFor(player: Option[Player]): collection.Set[Alliance] =
    enemiesFor(allianceIdFor(player))

  /**
   * Returns Alliance set which are naps with this alliance.
   */
  def napsFor(allianceId: Int) =
    (alliancesMap.keySet - allianceId -- enemies(allianceId)).map { alliancesMap(_) }

  /**
   * Returns Alliance set which are naps with this player.
   */
  def napsFor(player: Option[Player]): collection.Set[Alliance] =
    napsFor(allianceIdFor(player))

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
    killedBy(target) = killer.player
    val allianceId = playerCache(target.player)
    alliancesMap(allianceId).kill(target)
  }

  def allianceIdFor(player: Option[Player]) = playerCache(player)

  def allianceFor(player: Option[Player]) = alliancesMap(allianceIdFor(player))

  /**
   * Reset all initative lists keeping only alive units.
   */
  def reset() = L.debug("Reseting alliance initiative lists", () => {
      alliancesMap.foreach { case (allianceId, alliance) => alliance.reset }
      // Recalculate initiative numbers.
      initiatives = calculateInitiatives
  })

  /**
   * Returns JSON like map for alliances.
   *
   * Map(
   *   allianceId: Int -> Alliance
   * )
   */
  lazy val toMap: Alliances.DataMap = alliancesMap.map {
    case (allianceId, alliance) => (allianceId -> alliance.toMap)
  }
}
