package spacemule.modules.pmg.objects

import spacemule.helpers.Converters._
import spacemule.modules.pmg.persistence.objects.LocationRow

object Location extends Enumeration {
  type Kind = Value

  val Galaxy = Value(0, "galaxy")
  val SolarSystem = Value(1, "solar system")
  val SsObject = Value(2, "ss object")
  val Unit = Value(3, "unit")
  val Building = Value(4, "building")

  def apply(
    row: LocationRow, kind: Location.Kind, x: Option[Int], y: Option[Int]
  ) = new Location(row, kind, x, y)
}

class Location(
  val row: LocationRow, val kind: Location.Kind,
  val x: Option[Int], val y: Option[Int]
) {
  override def equals(other: Any) = other match {
    case other: Location => row == other.row && kind == other.kind &&
      x == other.x && y == other.y
    case _ => false
  }
}