package spacemule.modules.combat.objects

object Player {
  object Technologies {
    /**
     * Value that indicates that this technology applies to everything.
     */
    val AnyName = "*"

    /**
     * Map of combatant full name (Building::Thunder, Unit::Trooper, etc.) to
     * modifier.
     */
    type ModsMap = Map[String, Double]
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
    private def modsFrom(modsMap: Technologies.ModsMap, combatant: Combatant) = {
      val name = combatant match {
        case t: Troop => "Unit::" + t.name
        case b: Building => "Building::" + b.name
      }
      
      modsMap.getOrElse(name, 0d) + modsMap.getOrElse(Technologies.AnyName, 0d)
    }
  }
}

class Player(val id: Int, val allianceId: Option[Int],
             val technologies: Player.Technologies) {
  override def equals(other: Any) = other match {
    case player: Player => id == player.id
    case _ => false
  }
}
