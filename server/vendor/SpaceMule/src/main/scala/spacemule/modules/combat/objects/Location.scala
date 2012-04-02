package spacemule.modules.combat.objects

import spacemule.modules.pmg.objects.{Location => PMGLocation}

/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 4/2/12
 * Time: 12:11 PM
 * To change this template use File | Settings | File Templates.
 */

object Location {
  type Kind = PMGLocation.Kind

  val Galaxy = PMGLocation.Galaxy
  val SolarSystem = PMGLocation.SolarSystem
  val SsObject = PMGLocation.SsObject
  val Unit = PMGLocation.Unit
  val Building = PMGLocation.Building
}

class Location(
  val id: Int, val kind: PMGLocation.Kind,
  val x: Option[Int], val y: Option[Int]
) {
  override def equals(other: Any) = other match {
    case other: Location => id == other.id && kind == other.kind &&
      x == other.x && y == other.y
    case _ => false
  }
}
