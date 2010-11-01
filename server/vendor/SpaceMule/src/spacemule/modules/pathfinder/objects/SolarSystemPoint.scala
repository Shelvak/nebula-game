/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.objects

import spacemule.modules.pmg.objects

object SolarSystemPoint {
  def apply(planet: Planet) = new SolarSystemPoint(planet)
}

case class SolarSystemPoint(solarSystem: SolarSystem, position: Int,
                            angle: Int) extends Locatable
                                              with InSolarSystem {
  def this(planet: Planet) = this(planet.solarSystem, planet.position,
                                  planet.angle)
  
  def toServerLocation = ServerLocation(solarSystem.id,
                                        objects.Location.SolarSystemKind,
                                        Some(position), Some(angle))
  def solarSystemId = solarSystem.id
  def solarSystemPoint = this
}
