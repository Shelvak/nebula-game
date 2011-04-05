package spacemule.modules.combat.objects

import spacemule.modules.config.objects.Config

class Troop(val id: Int,
            val name: String,
            var level: Int,
            var hp: Int,
            val player: Option[Player],
            val flank: Int,
            val stance: Stance.Type,
            protected var _xp: Int,
            val troops: Option[Set[Troop]])
extends Combatant with Ordered[Troop] {
  val kind = Kind(Config.unitKind(name))
  val armor = Armor(Config.unitArmor(name))
  val armorModifier = Config.unitArmorModifier(name, level)
  val initiative = Config.unitInitiative(name)
  val volume = Config.unitVolume(name)
  val guns = List[Gun]()

  def metalCost = Config.unitMetalCost(name)
  def energyCost = Config.unitEnergyCost(name)
  def zetiumCost = Config.unitZetiumCost(name)

  val hitPoints = Config.unitHp(name)

  def compare(troop: Troop): Int = {
    if (flank != troop.flank) return flank.compare(troop.flank)
    volume.compare(troop.volume)
  }
}
