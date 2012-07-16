package spacemule.modules.combat.objects

import scala.{collection => sc}
import java.{util => ju}
import scala.collection.JavaConversions._

object Player {
  object Points {
    def empty = Points(0, 0, 0, 0, 0)
  }

  case class Points(economy: Int, science: Int, army: Int, war: Int,
                    victory: Int)
  
  object Technologies {
    /**
     * Map of combatant full name (Building::Thunder, Unit::Trooper, etc.) to
     * modifier.
     * 
     * Modifier example: 0.25 would mean 25% more damage.
     */
    type ModsMap = sc.Map[String, Double]
    type JavaModsMap = ju.Map[String, Double]
  }

  class Technologies(
    damageMods: Technologies.ModsMap, 
    armorMods: Technologies.ModsMap,
    criticalMods: Technologies.ModsMap,
    absorptionMods: Technologies.ModsMap
  ) {
    def this(
      damageMods: Technologies.JavaModsMap,
      armorMods: Technologies.JavaModsMap,
      criticalMods: Technologies.JavaModsMap,
      absorptionMods: Technologies.JavaModsMap
    ) = this(
      mapAsScalaMap(damageMods), mapAsScalaMap(armorMods),
      mapAsScalaMap(criticalMods), mapAsScalaMap(absorptionMods)
    )

    /**
     * Returns damage mod from technologies for combatant.
     */
    def damageModFor(combatant: Combatant) = modsFrom(damageMods, combatant)

    /**
     * Returns armor mod from technologies for combatant.
     */
    def armorModFor(combatant: Combatant) = modsFrom(armorMods, combatant)

    /**
     * Returns critical chance from technologies for combatant.
     */
    def criticalChanceFor(combatant: Combatant) =
      modsFrom(criticalMods, combatant)

    /**
     * Returns absorption chance from technologies for combatant.
     */
    def absorptionChanceFor(combatant: Combatant) =
      modsFrom(absorptionMods, combatant)
    
    /**
     * Return mod for combatant from given mod map.
     */
    private def modsFrom(modsMap: Technologies.ModsMap, combatant: Combatant) =
      modsMap.getOrElse(combatant.rubyName, 0d)
  }

  val DefaultOverpopulation = 1.0
}

class Player(
  val id: Long,
  val name: String,
  val allianceId: Option[Long],
  val points: Player.Points,
  val technologies: Player.Technologies,
  // Returns value (0..1] for combat mods. If player is overpopulated this
  // value will be < 1, else it will be 1.0.
  val overpopulation: Double = Player.DefaultOverpopulation
) {
  require(
    overpopulation > 0 && overpopulation <= 1,
    "overpopulation must be (0..1] for " + toString + ", but it was " +
    overpopulation
  )

  override def equals(other: Any) = other match {
    case player: Player => id == player.id
    case _ => false
  }

  override def toString = "Player(%s, id %d)".format(name, id)
}
