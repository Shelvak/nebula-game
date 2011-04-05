package spacemule.modules.combat.objects

import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config
import java.math.BigDecimal

object Gun {
  def apply(owner: Combatant, definition: Map[String, Any], index: Int) =
    new Gun(
      index,
      owner,
      Kind(definition.getOrError("reach").asInstanceOf[String]),
      Damage(definition.getOrError("damage").asInstanceOf[String]),
      Config.formula(
        definition.getOrError("dpt").toString,
        Map("level" -> new BigDecimal(owner.level))
      ).intValue,
      definition.getOrError("period").asInstanceOf[Int]
    )
}

class Gun(val index: Int, owner: Combatant, val kind: Kind.Value,
          val damage: Damage.Type, dpt: Int, period: Int) {
  /**
   * Cooldown counter for gun.
   */
  private var cooldown = 0

  /**
   * Is this weapon cooling down?
   */
  def isCoolingDown = cooldown > 0
  /**
   * Cool the gun. Reduces cooldown counter.
   */
  def cool = cooldown -= 1

  /**
   * Shoots target. Returns damage dealt.
   */
  def shoot(target: Combatant): Int = {
    if (isCoolingDown) throw new IllegalStateException(
      "Cannot shoot - gun hasn't finished cooling down. Cooldown: %d".format(
        cooldown))

    cooldown = period - 1

    val damagePercent = Config.damageModifier(this.damage, target.armor) *
      (1 + owner.technologiesDamageMod) * owner.stanceDamageMod
    val armorPercent = (1 + target.technologiesArmorMod) *
      (1 + target.armorModifier) * target.stanceArmorMod

    val damage = (dpt * damagePercent / armorPercent).round

    if (damage > target.hp) target.hp
    else if (damage < 1) 1
    else damage.toInt
  }
}