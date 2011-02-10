package spacemule.modules.pmg.objects.solar_systems

import spacemule.modules.pmg.objects._
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.objects.ss_objects.Planet

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 8:20:06 PM
 * To change this template use File | Settings | File Templates.
 */

class Homeworld extends SolarSystem {
  if (planetCount + 1 > orbitCount) {
    throw new Exception(
      "Planet count %d is more than orbit count %d for Homeworld ss!".format(
      planetCount + 1, orbitCount))
  }

  override def createPlanets() = {
    createObjectType(1) { () => new ss_objects.Homeworld() }
    createObjectType(planetCount) { () => new Planet(
        Config.homeSolarSystemPlanetsArea) }
  }

  override def createJumpgates() = {
    createObjectType(jumpgateCount) { () => new ss_objects.HomeJumpgate() }
  }

  override protected def orbitUnitChances =
    Config.homeworldSsObjectOrbitUnitsChances

  override protected def orbitUnits =
    Config.homeworldOrbitUnits
}