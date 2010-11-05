/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.objects

import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects

case class Planet(
  id: Int, solarSystem: SolarSystem, coords: Coords
) extends Locatable with InSolarSystem {
  def toServerLocation = ServerLocation(id, objects.Location.PlanetKind,
                                        None, None)
  def solarSystemId = solarSystem.id
  def solarSystemPoint = SolarSystemPoint(solarSystem, coords)
}
