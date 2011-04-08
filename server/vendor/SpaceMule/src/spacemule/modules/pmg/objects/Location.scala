package spacemule.modules.pmg.objects

import spacemule.helpers.Converters._

object Location extends Enumeration {
  type Kind = Value

  val Galaxy = Value(0, "galaxy")
  val SolarSystem = Value(1, "solar system")
  val Planet = Value(2, "planet")
  val Unit = Value(3, "unit")
  val BuildingKind = Value(4, "building")

  def apply(id: Int, kind: Location.Kind, x: Option[Int], y: Option[Int]) =
    new Location(id, kind, x, y)

  /**
   * Reads location from such map:
   *
   * Map(
   *   "id" -> Int,
   *   "kind" -> Int,
   *   "x" -> Int | null
   *   "y" -> Int | null
   * )
   *
   * Optionally "kind" can be substituted with "type".
   */
  def read(input: Map[String, Any]) = {
    val kind = Location(
      (input.get("kind") match {
        case None => input.getOrError("type", "neither kind nor type was defined!")
        case Some(kind) => kind
      }).asInstanceOf[Int]
    )

    new Location(
      input.getOrError("id").asInstanceOf[Int],
      kind,
      kind match {
        case Planet => None
        case _ => Some(input.getOrError("x").asInstanceOf[Int])
      },
      kind match {
        case Planet => None
        case _ => Some(input.getOrError("y").asInstanceOf[Int])
      }
    )
  }
}

class Location(val id: Int, val kind: Location.Kind, val x: Option[Int],
               val y: Option[Int]) {
  override def equals(other: Any) = other match {
    case other: Location => id == other.id && kind == other.kind &&
      x == other.x && y == other.y
    case _ => false
  }
}