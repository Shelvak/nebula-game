/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.objects

import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects
import spacemule.modules.config.objects.Config

object SolarSystemPoint {
  def apply(planet: Planet) = new SolarSystemPoint(planet)
}

case class SolarSystemPoint(
  solarSystem: SolarSystem, coords: Coords
) extends Locatable with InSolarSystem {
  def this(planet: Planet) = this(planet.solarSystem, planet.coords)
  
  def toServerLocation = ServerLocation(solarSystem.id,
                                        objects.Location.SolarSystemKind,
                                        Some(coords.position),
                                        Some(coords.angle),
                                        Config.planetLinkWeight)
  def solarSystemId = solarSystem.id
  def solarSystemPoint = this
}
