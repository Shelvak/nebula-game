package spacemule.modules.combat.objects

import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config

object Gun {
  def apply(owner: Combatant, definition: Map[String, Any], index: Int) =
    new Gun(
      index,
      owner,
      Kind(definition.getOrError("reach").asInstanceOf[String]),
      Damage(definition.getOrError("damage").asInstanceOf[String]),
      Config.formula(
        definition.getOrError("dpt").toString,
        Map("level" -> owner.level)
      ).intValue,
      definition.getOrError("period").asInstanceOf[Int]
    )
}

class Gun(val index: Int, owner: Combatant, val kind: Kind.Value,
          damage: Damage.Type, dpt: Int, period: Int) {
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

    val damage = (
      dpt * (
        Config.damageModifier(this.damage, target.armor) +
        owner.technologiesDamageMod +
        (owner.stanceDamageMod - 1) -
        (target.stanceArmorMod - 1) -
        target.armorModifier
      )
    ).round

    if (damage > target.hp) target.hp
    else if (damage < 1) 1
    else damage.toInt
  }
}