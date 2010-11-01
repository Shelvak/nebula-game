/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.objects

import spacemule.modules.pmg.objects

object GalaxyPoint {
  def apply(solarSystem: SolarSystem) = new GalaxyPoint(solarSystem)
}

case class GalaxyPoint(id: Int, x: Int, y: Int) extends Locatable {
  def this(solarSystem: SolarSystem) = this(solarSystem.galaxyId,
                                            solarSystem.x,
                                            solarSystem.y)

  def toServerLocation = ServerLocation(id, objects.Location.GalaxyKind,
                                        Some(x), Some(y))
}
