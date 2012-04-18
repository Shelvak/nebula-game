package spacemule.modules.combat.objects

/**
 * Location will all necessary data for game client.
 */
class ClientLocation(
  val id: Int, val kind: Location.Kind,
  val x: Option[Int], val y: Option[Int],
  val name: Option[String], val terrain: Option[Int],
  val solarSystemId: Option[Int]
) {
  /**
   * Compare this to other object.
   */
  override def equals(other: Any) = other match {
    case other: ClientLocation =>
      // We skip name because names of planets can be changed by players
      id == other.id && kind == other.kind && x == other.x && y == other.y &&
        terrain == other.terrain && solarSystemId == other.solarSystemId
    case _ => false
  }
}
