/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.objects

case class SolarSystem(id: Int, x: Int, y: Int, galaxyId: Int) {
  def galaxyPoint = GalaxyPoint(galaxyId, x, y)
}
