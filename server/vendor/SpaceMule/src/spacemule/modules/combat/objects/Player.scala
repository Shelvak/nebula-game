package spacemule.modules.combat.objects

object Player {
  def idForJson(player: Option[Player]) = player match {
    case Some(player) => player.id
    case None => null
  }

  object Technologies {
    /**
     * Map of combatant full name (Building::Thunder, Unit::Trooper, etc.) to
     * modifier.
     */
    type ModsMap = Map[String, Double]

    def empty = new Player.Technologies(Map(), Map())
  }

  class Technologies(
    damageMods: Technologies.ModsMap, 
    armorMods: Technologies.ModsMap
  ) {
    /**
     * Returns damage mod from technologies for combatant.
     */
    def damageModFor(combatant: Combatant) = modsFrom(damageMods, combatant)
    /**
     * Returns armor mod from technologies for combatant.
     */
    def armorModFor(combatant: Combatant) = modsFrom(armorMods, combatant)

    /**
     * Return mod for combatant from given mod map.
     */
    private def modsFrom(modsMap: Technologies.ModsMap, combatant: Combatant) =
      modsMap.getOrElse(combatant.rubyName, 0d)
  }
}

class Player(val id: Int, val name: String, val allianceId: Option[Int],
             val technologies: Player.Technologies=Player.Technologies.empty) {
  override def equals(other: Any) = other match {
    case player: Player => id == player.id
    case _ => false
  }

  override def toString = "Player(%d)".format(id)
}
