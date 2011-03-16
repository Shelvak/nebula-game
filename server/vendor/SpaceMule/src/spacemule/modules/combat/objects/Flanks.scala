package spacemule.modules.combat.objects

import scala.collection.mutable
import scala.collection.immutable._
import spacemule.helpers.Converters._
import spacemule.helpers.{Random, RandomArray}
import spacemule.modules.config.objects.Config

/**
 * Companion object to Flanks class.
 */
object Flanks {
  def toInitiativeList(combatants: Set[Combatant]): List[Combatant] = {
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
class Flanks(combatants: Set[Combatant]) {
  /**
   * List of combatants not yet activated sorted by descending initiative.
   */
  private var initiativeList = Flanks.toInitiativeList(combatants)

  // Alias for map that holds alive combatants.
  type CombatantMap = RandomArray[Combatant]

  /**
   * Alive combatants which are grouped by flank.
   */
  private val alive = (0 until Config.maxFlankIndex).map {
    index => new CombatantMap(combatants.size) }
  combatants.foreach { combatant => alive(combatant.flank) += combatant }

  /**
   * Dead combatants.
   */
  private val _dead = mutable.HashSet[Combatant]()
  /**
   * Immutable set of dead combatants.
   */
  def dead = _dead.toSet

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
   * Resets initative list for these flanks.
   */
  def reset(): Unit = initiativeList = Flanks.toInitiativeList(combatants)

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
   * Finds map for alive combatant. Returns None if combatant is not alive.
   */
  def findSetForAlive(combatant: Combatant): Option[CombatantMap] = {
    alive.foreach { set => if (set.contains(combatant)) return Some(set) }
    None
  }

  /**
   * Returns a target combatant which you can shoot.
   */
  def target(): Option[Combatant] = {
    alive.foreachWithIndex { case (array, index) =>
        // Flank gets picked if it is not empty,
        // and proc'es right or it is the last flank.
        if (array.size > 0 && (
            Random.boolean(Config.combatLineHitChance) || index == alive.size - 1
        )) return Some(array.random)
    }

    None
  }

  /**
   * Marks combatant as killed.
   */
  def kill(combatant: Combatant): Unit = {
    findSetForAlive(combatant) match {
      case Some(set) => {
          set -= combatant
          _dead.add(combatant)
      }
      case None => throw new IllegalArgumentException(
        "Cannot kill combatant %s because it is not alive!".format(combatant))
    }
  }
}