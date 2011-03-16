package spacemule.modules.combat.objects

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
}