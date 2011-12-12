/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.combat.objects

import spacemule.modules.config.objects.Config

class Building(val id: Long, val player: Option[Player], val name: String,
               var hp: Int, var level: Int)
extends Combatant {
  val rubyName = "Building::" + name
  val kind = Kind.Ground
  val armor = Armor.Fortified
  val armorModifier = 0.0
  /**
   * Buildings stand in first flank.
   */
  val flank = 0
  val initiative = Config.buildingInitiative(name)
  val stance = Stance.Normal
  val hitPoints = Config.buildingHp(name)
  protected var _xp = 0
  /**
   * Buildings don't accumulate xp.
   */
  override def xp_=(value: Int) {
    throw new UnsupportedOperationException("Buildings cannot gain XP!")
  }

  def gainsXp = false

  def metalCost = Config.metalCost(this)
  def energyCost = Config.energyCost(this)
  def zetiumCost = Config.zetiumCost(this)

  override def toString =
    "Building[%s/%d](id:%d, hp:%d/%d, lvl: %d, plr: %s)".format(
      name, initiative, id, hp, hitPoints, level, player
    )
}
