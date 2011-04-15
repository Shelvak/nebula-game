package spacemule.modules.combat.objects

/**
 * Available participant armor types.
 */
object Armor extends Enumeration {
  type Type = Value

  val Light = Value("light")
  val Normal = Value("normal")
  val Heavy = Value("heavy")
  val Fortified = Value("fortified")

  def apply(s: String) = s match {
    case "light" => Light
    case "normal" => Normal
    case "heavy" => Heavy
    case "fortified" => Fortified
  }

  def toString(armor: Type) = armor match {
    case Light => "light"
    case Normal => "normal"
    case Heavy => "heavy"
    case Fortified => "fortified"
  }
}
