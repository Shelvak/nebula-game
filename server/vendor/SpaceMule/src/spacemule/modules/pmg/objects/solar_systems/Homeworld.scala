package spacemule.modules.pmg.objects.solar_systems

import spacemule.modules.pmg.objects._
import spacemule.modules.config.objects.Config

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 8:20:06 PM
 * To change this template use File | Settings | File Templates.
 */

class Homeworld(val player: Player) extends SolarSystem {
  override def createPlanets() = {
    createObjectType(1) { () => new ss_objects.Homeworld(player) }
    super.createPlanets()
  }

  override def createJumpgates() = {
    createObjectType(jumpgateCount) { () => new ss_objects.HomeJumpgate() }
  }

  override protected def orbitUnitChances =
    Config.homeworldSsObjectOrbitUnitsChances

  override protected def orbitUnits =
    Config.homeworldOrbitUnits
}