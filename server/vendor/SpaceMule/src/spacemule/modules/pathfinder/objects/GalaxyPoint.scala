/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.objects

import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects

case class GalaxyPoint(id: Int, coords: Coords) extends Locatable {
  def toServerLocation = ServerLocation(id, objects.Location.GalaxyKind,
                                        Some(coords.x), Some(coords.y), 1)
}
