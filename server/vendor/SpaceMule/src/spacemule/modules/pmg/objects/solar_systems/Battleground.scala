/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.objects.solar_systems

import spacemule.helpers.Converters._
import spacemule.modules.pmg.objects.SolarSystem
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.objects.ss_objects.BgPlanet
import spacemule.modules.pmg.objects.ss_objects.Jumpgate

/**
 * Solar system in which most battles happen.
 */
class Battleground(val galaxyId: Int) extends SolarSystem {
  override def createPlanets() = {
    Config.battlegroundPlanetPositions.foreachWithIndex {
      case (coords, index) => initializeAndAdd(new BgPlanet(index), coords)
    }
  }

  override def createJumpgates() = {
    Config.battlegroundJumpgatePositions.foreach { coords =>
      initializeAndAdd(new Jumpgate(), coords)
    }
  }
}
