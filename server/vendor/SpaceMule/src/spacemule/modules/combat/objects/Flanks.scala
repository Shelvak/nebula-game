package spacemule.modules.combat.objects

import scala.collection.mutable
import scala.collection.immutable._
import spacemule.helpers.Converters._
import spacemule.helpers.Random
import spacemule.modules.config.objects.Config

/**
 * Companion object to Flanks class.
 */
object Flanks {
  def toInitiativeLists(combatants: Iterable[Combatant]) =
    combatants.toList.groupBy { _.initiative }
}

/**
 * Object that represents all flanks for given set of combatants.
 */
class Flanks(description: String, combatants: Set[Combatant]) {
  /**
   * List of combatants not yet activated sorted by descending initiative.
   */
  private var initiativeLists = Flanks.toInitiativeLists(combatants)

  /**
   * Alive combatants which are grouped by flank.
   */
  private val alive = (0 until Config.maxFlankIndex).map {
    index => new Flank(index) }
  combatants.foreach { combatant => alive(combatant.flank) += combatant }

  /**
   * Take next combatant by initiative from this list. Reduces initiative list.
   *
   * Returns None if we do not have any combatants with such initiative.
   */
  def take(initiative: Int): Option[Combatant] = {
    initiativeLists.get(initiative) match {
      case Some(list) => {
          list match {
            case head :: tail => {
                initiativeLists = initiativeLists.updated(initiative, tail)
                Some(head)
              }
            case Nil => None
          }
        }
      case None => None
    }
  }

  /**
   * Set of initiatives for these flanks.
   */
  def initiatives = initiativeLists.keySet

  /**
   * Resets initative list for these flanks using alive units.
   */
  def reset(): Unit = initiativeLists = Flanks.toInitiativeLists(
    alive.map { _.combatants }.flatten)

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
    // Filter only non empty flanks.
    val flanks = alive.filterNot { _.isEmpty }
    val maxIndex = flanks.size - 1
    // Try to find a target in there.
    flanks.foreachWithIndex { case (flank, index) =>
        // Flank gets picked if it is not empty,
        // and proc'es right or it is the last flank.
        if (index == maxIndex || Random.boolean(Config.combatLineHitChance)) {
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
      }
      case None => throw new IllegalArgumentException(
        "Cannot kill combatant %s because it is not alive!".format(combatant))
    }
  }
}