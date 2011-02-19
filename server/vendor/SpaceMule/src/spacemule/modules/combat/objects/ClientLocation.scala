package spacemule.modules.combat.objects

import spacemule.modules.pmg.objects.Location

/**
 * Location will all necesarry data for game client.
 */
case class ClientLocation(id: Int, kind: Int, x: Option[Int], y: Option[Int],
                     name: Option[String], terrain: Option[Int], 
                     solarSystemId: Option[Int]
) extends Location(id, kind, x, y) {
  /**
   * Compare this to other object.
   */
  override def ==(other: AnyRef) = {
    other match {
      case other: ClientLocation => {
          // We skip name because names of planets can be changed by players
          super.==(other) && terrain == other.terrain &&
            solarSystemId == other.solarSystemId
      }
      case _ => false
    }
  }
}
