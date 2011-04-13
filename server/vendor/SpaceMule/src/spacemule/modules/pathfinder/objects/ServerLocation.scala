package spacemule.modules.pathfinder.objects

import spacemule.modules.pmg.objects.Location

case class ServerLocation(id: Int, kind: Location.Kind,
                          x: Option[Int], y: Option[Int],
                          timeMultiplier: Double) {
  def toMap: Map[String, Any] = {
    return Map[String, Any](
      "id" -> id,
      "type" -> kind.id,
      "x" -> (x match {
        case Some(int: Int) => int
        case None => null
      }),
      "y" -> (y match {
        case Some(int: Int) => int
        case None => null
      }),
      "time" -> timeMultiplier
    )
  }
}
