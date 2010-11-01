package spacemule.modules.pmg.objects

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 16, 2010
 * Time: 3:35:22 PM
 * To change this template use File | Settings | File Templates.
 */

object Location {
  val GalaxyKind = 0
  val SolarSystemKind = 1
  val PlanetKind = 2
  val UnitKind = 3
  // Special type of location. location_id is not a building id, but rather
  // a planet id, and x, y references to this building x, y in the planet.
  val BuildingKind = 4
}

case class Location(id: Int, kind: Int, x: Option[Int], y: Option[Int])