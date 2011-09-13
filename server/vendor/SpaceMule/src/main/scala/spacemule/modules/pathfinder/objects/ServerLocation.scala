package spacemule.modules.pathfinder.objects

import spacemule.modules.pmg.objects.Location
import spacemule.modules.pmg.classes.geom.Coords

case class ServerLocation(id: Int,
                          kind: Location.Kind,
                          coords: Option[Coords],
                          timeMultiplier: Double)
