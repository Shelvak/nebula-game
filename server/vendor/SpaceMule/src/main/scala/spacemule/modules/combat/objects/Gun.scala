package spacemule.modules.combat.objects

import core.Values._
import spacemule.helpers.Random
import spacemule.modules.config.objects.{FormulaCalc, Config}

object Gun {
  def apply(owner: Combatant, definition: Config.GunDefinition, index: Int) =
    new Gun(
      index,
      owner,
      Kind(definition("reach").toString),
      Damage(definition("damage").toString),
      FormulaCalc.calc(
        definition("dpt").toString,
        Map("level" -> owner.level.toDouble)
      ).intValue,
      definition("period").asInstanceOf[Long]
    )

  /**
   * Returns Seq of guns for this combatant.
   */
  def gunsFor(combatant: Combatant) = (combatant match {
      case t: Troop => Config.troopGunDefinitions(t.name)
      case b: Building => Config.buildingGunDefinitions(b.name)
  }).zipWithIndex.map { case (definition, index) =>
    Gun(combatant, definition, index)
  }
}

class Gun(val index: Int, owner: Combatant, val kind: Kind.Value,
          val damage: Damage.Type, dpt: Int, period: Int) {
  override def toString = "Gun(%d, %s, %s, dpt: %d@%d)".format(
    index, kind, damage, dpt, period
  )

  /**
   * Cooldown counter for gun.
   */
  private var cooldown = 0

  /**
   * Shoots target. Returns damage dealt. If damage is 0 then this gun is still
   * cooling down.
   */
  def shoot(target: Combatant): Int = {
    if (cooldown > 0) {
      cooldown -= 1
      return 0
    }
    else {
      cooldown = period - 1

      val damagePercent = Config.damageModifier(this.damage, target.armor) *
        (1 + owner.technologiesDamageMod) * owner.stanceDamageMod
      val armorPercent = (1 + target.technologiesArmorMod) *
        (1 + target.armorModifier) * target.stanceArmorMod

      var damage = dpt * damagePercent / armorPercent *
        owner.overpopulationMod / target.overpopulationMod
      
      if (Random.boolean(owner.criticalChance))
        damage *= Config.criticalMultiplier
      if (Random.boolean(target.absorptionChance))
        damage /= Config.absorptionDivider

      damage = damage.round

      if (damage > target.hp) target.hp
      else if (damage < 1) 1
      else damage.toInt
    }
  }
}