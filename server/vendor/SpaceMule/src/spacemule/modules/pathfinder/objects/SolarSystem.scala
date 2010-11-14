/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.objects

import spacemule.modules.pmg.classes.geom.Coords

case class SolarSystem(id: Int, coords: Coords, galaxyId: Int) {
  def galaxyPoint = GalaxyPoint(galaxyId, coords)
}
