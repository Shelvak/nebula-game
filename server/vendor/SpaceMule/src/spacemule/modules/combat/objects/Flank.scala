/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.combat.objects

import spacemule.helpers.RandomArray
import scala.collection.mutable.HashMap
import spacemule.helpers.Converters._
import spacemule.helpers.{StdErrLog => L}

/**
 * One flank with different unit types.
 */
class Flank(index: Int) {
  private val byArmor = Armor.values.map { kind =>
    (kind, new RandomArray[Combatant]()) }.toMap

  /**
   * Cache for player -> combatant count pairs in this flank.
   */
  private val playerCountCache = HashMap[Option[Player], Int]()

  override def toString = "Flank(%d)".format(index)

  /**
   * Add combatant to flank.
   */
  def +=(combatant: Combatant) = {
    byArmor(combatant.armor) += combatant

    // Cache the count.
    playerCountCache ||= (combatant.player, 0)
    playerCountCache(combatant.player) += 1
  }

  /**
   * Remove combatant from flank.
   */
  def -=(combatant: Combatant) = {
    byArmor(combatant.armor) -= combatant
    playerCountCache(combatant.player) -= 1
  }

  /**
   * Returns all combatants in this flank.
   */
  def combatants = byArmor.values.flatten

  /**
   * Does this flank contains this combatant?
   */
  def contains(combatant: Combatant) =
    byArmor(combatant.armor).contains(combatant)

  /**
   * Check if player has any combatants left in this flank
   */
  def hasCombatants(player: Option[Player]) =
    playerCountCache.getOrElse(player, 0) != 0
//
//  /**
//   * Returns total number of combatants in this flank.
//   */
//  def size = byArmor.foldLeft(0) { case (sum, (armor, array)) =>
//      sum + array.size }

  /**
   * Is this flank empty?
   */
  def isEmpty: Boolean = {
    byArmor.foreach { case (armor, array) => if (! array.isEmpty) return false }
    true
  }

  /**
   * Return random combatant from flank. Can return None if no combatants are
   * in this flank.
   */
  def random = {
    L.debug("Selecting RANDOM target from %s".format(this))
    val withCombatants = byArmor.filter { case (armor, array) =>
      array.size > 0
    }

    if (withCombatants.size == 0) None
    else Some(withCombatants.values.toIndexedSeq.random.random)
  }

  /**
   * Return combatant from flank to which damage type will do most damage.
   * Can return None if no combatants are in this flank.
   */
  def target(damage: Damage.Type): Option[Combatant] = {
    L.debug("Selecting BEST target from %s".format(this))
    Damage.bestArmorTypes(damage).foreach { armor =>
      val targets = byArmor(armor)
      if (! targets.isEmpty) return Some(targets.random)
    }

    None
  }
}
