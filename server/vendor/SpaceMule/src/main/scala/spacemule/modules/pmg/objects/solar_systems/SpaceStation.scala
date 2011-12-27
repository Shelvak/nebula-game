package spacemule.modules.pmg.objects.solar_systems

import spacemule.modules.pmg.objects.{Player, SolarSystem}


/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 12/27/11
 * Time: 1:41 PM
 * To change this template use File | Settings | File Templates.
 */

class SpaceStation(val player: Player) extends SolarSystem(None) {
  override val kind = SolarSystem.SpaceStation
}