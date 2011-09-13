package spacemule.modules.pathfinder.objects

import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects

case class GalaxyPoint(id: Int, coords: Coords, timeModifier: Double=1)
extends Locatable {
  override def toServerLocation = toServerLocation(timeModifier)
  def toServerLocation(timeModifier: Double) = 
    ServerLocation(id, objects.Location.Galaxy, Some(coords), timeModifier)
}
