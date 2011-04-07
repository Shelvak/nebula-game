package spacemule.modules.combat.objects

import spacemule.modules.config.objects.Config

class Troop(val id: Int,
            val name: String,
            var level: Int,
            var hp: Int,
            val player: Option[Player],
            val flank: Int,
            val stance: Stance.Type,
            protected var _xp: Int)
extends Combatant with Ordered[Troop] {
  val rubyName = "Unit::" + name
  val kind = Kind(Config.unitKind(name))
  val armor = Armor(Config.unitArmor(name))
  val armorModifier = Config.unitArmorModifier(name, level)
  val initiative = Config.unitInitiative(name)
  val volume = Config.unitVolume(name)

  def metalCost = Config.unitMetalCost(name)
  def energyCost = Config.unitEnergyCost(name)
  def zetiumCost = Config.unitZetiumCost(name)

  val hitPoints = Config.unitHp(name)

  def compare(troop: Troop): Int = {
    if (flank != troop.flank) return flank.compare(troop.flank)
    volume.compare(troop.volume)
  }

  override def toString =
    "Troop[%s/a:%s/i:%d/s:%s](id:%d, hp:%d/%d, xp:%d, lvl: %d, flnk: %d, plr: %s)".format(
      name, armor, initiative, stance, id, hp, hitPoints, xp, level, flank,
      player
    )
}
