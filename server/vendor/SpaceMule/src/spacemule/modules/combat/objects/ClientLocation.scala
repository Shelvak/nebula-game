package spacemule.modules.combat.objects

import spacemule.modules.pmg.objects.Location

/**
 * Location will all necesarry data for game client.
 */
class ClientLocation(override val id: Int, override val kind: Location.Kind,
                     override val x: Option[Int], override val y: Option[Int],
                     val name: Option[String],
                     val terrain: Option[Int], val solarSystemId: Option[Int]
) extends Location(id, kind, x, y) {
  /**
   * Compare this to other object.
   */
  override def equals(other: Any) = other match {
    case other: ClientLocation =>
      // We skip name because names of planets can be changed by players
      //id == other.id && kind == other.kind && x == other.x && y == other.y
      super.equals(other) &&
        terrain == other.terrain && solarSystemId == other.solarSystemId
    case _ => false
  }
}
