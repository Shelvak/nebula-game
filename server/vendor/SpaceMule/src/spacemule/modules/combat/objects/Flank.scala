/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.combat.objects

import spacemule.helpers.RandomArray
import spacemule.helpers.Converters._

/**
 * One flank with different unit types.
 */
class Flank {
  private val byArmor = Armor.values.map { kind =>
    (kind, new RandomArray[Combatant]()) }.toMap

  /**
   * Add combatant to flank.
   */
  def +=(combatant: Combatant) = byArmor(combatant.armor) += combatant

  /**
   * Remove combatant from flank.
   */
  def -=(combatant: Combatant) = byArmor(combatant.armor) -= combatant

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
   * Returns total number of combatants in this flank.
   */
  def size = byArmor.foldLeft(0) { case (sum, (armor, array)) =>
      sum + array.size }

  /**
   * Return random combatant from flank. Can return None if no combatants are
   * in this flank.
   */
  def random = {
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
    Damage.bestArmorTypes(damage).foreach { armor =>
      val targets = byArmor(armor)
      if (! targets.isEmpty) return Some(targets.random)
    }

    None
  }
}
