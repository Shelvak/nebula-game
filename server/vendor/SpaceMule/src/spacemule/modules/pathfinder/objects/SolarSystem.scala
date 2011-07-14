/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.objects

import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.classes.geom.Coords

case class SolarSystem(id: Int, coords: Option[Coords], galaxyId: Int) {
  def galaxyPoint = coords match {
    case Some(coords) => GalaxyPoint(galaxyId, coords)
    case None => error("Cannot give galaxy point for battleground solar system!")
  }
  
  /**
   * Is this solar system a global battleground?
   */
  def isGlobalBattleground = coords.isEmpty
  
  /**
   * Return time multiplier for solar system.
   */
  def wormholeHopMultiplier = Config.wormholeHopMultiplier(this)

  /**
   * Filter points and return coords that belong to this solar system.
   */
  def filterPoints(points: Seq[SolarSystemPoint]): Seq[Coords] = {
    points.filter { point => point.solarSystemId == id }.map {
      point => point.coords
    }
  }
}
