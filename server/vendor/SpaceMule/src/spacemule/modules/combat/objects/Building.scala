/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.combat.objects

import spacemule.modules.config.objects.Config

class Building(val id: Int, val player: Option[Player], val name: String)
extends Combatant {
  val kind = Kind.Ground
  val armor = Armor.Fortified
  val armorModifier = 0.0
  val flank = Config.maxFlankIndex - 1
  val initiative = Config.buildingInitiative(name)
  val guns = List[Gun]()
  val stance = Stance.Normal
}
