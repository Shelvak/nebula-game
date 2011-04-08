package spacemule.modules.combat.post_combat

import spacemule.modules.combat.objects._

class WreckageCalculator(combatants: Iterable[Combatant]) {
  lazy val (metal, energy, zetium) = {
    var (metal, energy, zetium) = (0d, 0d, 0d)
    combatants.foreach { combatant =>
      if (combatant.isDead) {
        metal += Wreckage.metalWreckage(combatant)
        energy += Wreckage.energyWreckage(combatant)
        zetium += Wreckage.zetiumWreckage(combatant)
      }
    }

    (metal, energy, zetium)
  }

  def asJson = Map(
    "metal" -> metal,
    "energy" -> energy,
    "zetium" -> zetium
  )
}
