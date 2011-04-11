package spacemule.modules.combat.objects

class KilledBy {
  /**
   * Map of who was killed by who.
   */
  private var map = Map[Combatant, Option[Player]]()

  def update(victim: Combatant, killer: Option[Player]) =
    map = map.updated(victim, killer)

  def asJson = map.map { case (victim, killer) =>
      // We use string ids because we can't pass objects via JSON and 
      // buildings/troops can have same ideas.
      val stringId = victim match {
        case t: Troop => "t:" + t.id
        case b: Building => "b:" + b.id
      }
      val killerId = killer match {
        case None => null
        case Some(player) => player.id
      }
      
      (stringId -> killerId)
  }
}
