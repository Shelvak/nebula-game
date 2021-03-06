package spacemule.modules.combat.objects

import spacemule.modules.config.objects.Config

/**
 * Available damage types.
 */
object Damage extends Enumeration {
  type Type = Value

  val Piercing = Value("piercing")
  val Normal = Value("normal")
  val Explosive = Value("explosive")
  val Siege = Value("siege")

  def apply(s: String) = s match {
    case "piercing" => Piercing
    case "normal" => Normal
    case "explosive" => Explosive
    case "siege" => Siege
  }

  def toString(damage: Type) = damage match {
    case Piercing => "piercing"
    case Normal => "normal"
    case Explosive => "explosive"
    case Siege => "siege"
  }

  /**
   * List of best armor types for this damage. Armor types are ordered
   * by how much damage this damage type does into them (descending).
   */
  lazy val bestArmorTypes = values.map { damage =>
    val armors = Armor.values.toList.sortWith { case (armor1, armor2) =>
      Config.damageModifier(damage, armor1) > Config.damageModifier(damage,
                                                                    armor2)
    }

    (damage, armors)
  }.toMap
}