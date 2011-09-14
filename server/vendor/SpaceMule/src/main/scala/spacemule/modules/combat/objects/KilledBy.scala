package spacemule.modules.combat.objects

object KilledBy {
  type DataMap = Map[Combatant, Option[Player]]
}

class KilledBy {
  /**
   * Map of who was killed by who.
   */
  private var map = Map[Combatant, Option[Player]]()

  def update(victim: Combatant, killer: Option[Player]) =
    map = map.updated(victim, killer)

  def toMap: KilledBy.DataMap = map
}
