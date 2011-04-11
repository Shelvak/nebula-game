package spacemule.modules.combat.objects

object Stance extends Enumeration {
  type Type = Value

  val Normal = Value(0, "normal")
  val Defensive = Value(1, "defensive")
  val Aggressive = Value(2, "aggresive")
}
