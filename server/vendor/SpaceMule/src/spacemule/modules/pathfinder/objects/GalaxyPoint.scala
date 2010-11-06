/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.objects

import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects

object GalaxyPoint {
  def apply(solarSystem: SolarSystem) = new GalaxyPoint(solarSystem)
}

case class GalaxyPoint(id: Int, coords: Coords) extends Locatable {
  def this(solarSystem: SolarSystem) = this(solarSystem.galaxyId,
                                            solarSystem.coords)

  def toServerLocation = ServerLocation(id, objects.Location.GalaxyKind,
                                        Some(coords.x), Some(coords.y))
}
