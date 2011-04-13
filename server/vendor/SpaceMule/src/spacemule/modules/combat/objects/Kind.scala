package spacemule.modules.combat.objects

/**
 * Available participant and gun kinds.
 */
object Kind extends Enumeration {
  val Ground = Value("ground")
  val Space = Value("space")

  def apply(s: String) = s match {
    case "ground" => Ground
    case "space" => Space
  }
}
