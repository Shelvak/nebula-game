/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.combat.objects

import spacemule.modules.config.objects.Config

class Building(val id: Int, val player: Option[Player], val name: String,
               var hp: Int, var level: Int)
extends Combatant {
  val kind = Kind.Ground
  val armor = Armor.Fortified
  val armorModifier = 0.0
  val flank = Config.maxFlankIndex - 1
  val initiative = Config.buildingInitiative(name)
  val guns = List[Gun]()
  val stance = Stance.Normal
  val hitPoints = Config.buildingHp(name)
  protected var _xp = 0
  /**
   * Buildings don't accumulate xp.
   */
  override def xp_=(value: Int) = ()

  def metalCost = Config.buildingMetalCost(name)
  def energyCost = Config.buildingEnergyCost(name)
  def zetiumCost = Config.buildingZetiumCost(name)
}
