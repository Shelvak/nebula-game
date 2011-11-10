package spacemule.modules.combat.objects

import spacemule.modules.config.objects.Config

class Troop(val id: Long,
            val name: String,
            var level: Int,
            var hp: Int,
            val player: Option[Player],
            val flank: Int,
            val stance: Stance.Type,
            protected var _xp: Int)
extends Combatant with Ordered[Troop] {
  val rubyName = "Unit::" + name
  val kind = Kind(Config.troopKind(name))
  val armor = Armor(Config.troopArmor(name))
  val armorModifier = Config.troopArmorModifier(name, level)
  val initiative = Config.troopInitiative(name)

  def metalCost = Config.troopMetalCost(name)
  def energyCost = Config.troopEnergyCost(name)
  def zetiumCost = Config.troopZetiumCost(name)

  val hitPoints = Config.troopHp(name)

  def compare(troop: Troop): Int = flank.compare(troop.flank)

  override def toString =
    "Troop[%s/a:%s/i:%d/s:%s](id:%d, hp:%d/%d, xp:%d, lvl: %d, flnk: %d, plr: %s)".format(
      name, armor, initiative, stance, id, hp, hitPoints, xp, level, flank,
      player
    )
}
