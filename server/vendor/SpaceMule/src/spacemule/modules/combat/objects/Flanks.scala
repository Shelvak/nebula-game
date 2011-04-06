package spacemule.modules.combat.objects

import scala.collection.mutable
import scala.collection.immutable._
import spacemule.helpers.Converters._
import spacemule.helpers.Random
import spacemule.modules.config.objects.Config
import spacemule.helpers.{StdErrLog => L}

/**
 * Companion object to Flanks class.
 */
object Flanks {
  def toInitiativeList(combatants: Iterable[Combatant]): List[Combatant] = {
    val grouped = combatants.toList.groupBy { _.initiative }

    /**
     * Maps hash with keys sorted in ascending order to immutable list where
     * combatants are ordered in descending initiative.
     */
    def mapToList(hash: Map[Int, List[Combatant]], keys: List[Int],
                  list: List[Combatant] = Nil): List[Combatant] = {
      keys match {
        case Nil => list
        case head :: rest => mapToList(hash, rest, hash(head) ::: list)
      }
    }

    return mapToList(grouped, grouped.keySet.toList.sorted)
  }
}

/**
 * Object that represents all flanks for given set of combatants.
 */
class Flanks(description: String, combatants: Set[Combatant]) {
  /**
   * List of combatants not yet activated sorted by descending initiative.
   */
  private var initiativeList = Flanks.toInitiativeList(combatants)

  /**
   * Alive combatants which are grouped by flank.
   */
  private val alive = (0 until Config.maxFlankIndex).map {
    index => new Flank() }
  combatants.foreach { combatant => alive(combatant.flank) += combatant }

//  /**
//   * Dead combatants.
//   */
//  private val _dead = mutable.HashSet[Combatant]()
//  /**
//   * Immutable set of dead combatants.
//   */
//  def dead = _dead.toSet

  /**
   * Take next combatant by initiative from this list. Reduces initiative list.
   */
  def take(): Option[Combatant] = {
    while (! initiativeList.isEmpty) {
      val combatant = initiativeList.head
      initiativeList = initiativeList.tail

      if (isAlive(combatant)) return Some(combatant)
    }

    return None
  }

  /**
   * Resets initative list for these flanks using alive units.
   */
  def reset(): Unit = L.debug(
    "Resetting initative list for Flanks(%s)".format(description), 
    () => initiativeList = Flanks.toInitiativeList(
      alive.map { _.combatants }.flatten)
  )

  /**
   * Does these flanks have any alive units?
   */
  def hasAlive: Boolean = {
    alive.foreach { flank => if (! flank.isEmpty) return true }
    false
  }

  /**
   * Check if this combatant is still active.
   */
  def isAlive(combatant: Combatant): Boolean = {
    findSetForAlive(combatant) match {
      case Some(set) => true
      case None => false
    }
  }

  /**
   * Check if this player has any combatants left alive.
   */
  def isAlive(player: Option[Player]): Boolean = {
    alive.foreach { flank => if (flank.hasCombatants(player)) return true }
    false
  }

  /**
   * Finds map for alive combatant. Returns None if combatant is not alive.
   */
  def findSetForAlive(combatant: Combatant): Option[Flank] = {
    alive.foreach { flank => if (flank.contains(combatant)) return Some(flank) }
    None
  }

  /**
   * Returns a target combatant which you can shoot.
   */
  def target(damage: Damage.Type): Option[Combatant] = {
    alive.foreachWithIndex { case (flank, index) =>
        // Flank gets picked if it is not empty,
        // and proc'es right or it is the last flank.
        if (flank.size > 0 && (
          index == alive.size - 1 || Random.boolean(Config.combatLineHitChance)
        )) {
          // Check if max damage shot proc'ed. If not - just return random dude.
          if (Random.boolean(Config.combatMaxDamageChance))
            return flank.target(damage)
          else
            return flank.random
        }
    }

    None
  }

  /**
   * Marks combatant as killed.
   */
  def kill(combatant: Combatant): Unit = {
    findSetForAlive(combatant) match {
      case Some(flank) => {
          flank -= combatant
//          _dead.add(combatant)
      }
      case None => throw new IllegalArgumentException(
        "Cannot kill combatant %s because it is not alive!".format(combatant))
    }
  }
}