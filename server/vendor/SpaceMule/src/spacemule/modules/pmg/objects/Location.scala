package spacemule.modules.pmg.objects

object Location {
  val GalaxyKind = 0
  val SolarSystemKind = 1
  val PlanetKind = 2
  val UnitKind = 3
  val BuildingKind = 4

  def apply(id: Int, kind: Int, x: Option[Int], y: Option[Int]) =
    new Location(id, kind, x, y)
}

class Location(val id: Int, val kind: Int, val x: Option[Int],
               val y: Option[Int]) {
  override def equals(other: Any) = other match {
    case other: Location => id == other.id && kind == other.kind &&
      x == other.x && y == other.y
    case _ => false
  }
}