/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.objects

import spacemule.modules.pmg.objects

case class Planet(id: Int, solarSystem: SolarSystem, position: Int,
                            angle: Int) extends Locatable
                                              with InSolarSystem {
  def toServerLocation = ServerLocation(id, objects.Location.PlanetKind,
                                        None, None)
  def solarSystemId = solarSystem.id
  def solarSystemPoint = SolarSystemPoint(solarSystem, angle, position)
}
