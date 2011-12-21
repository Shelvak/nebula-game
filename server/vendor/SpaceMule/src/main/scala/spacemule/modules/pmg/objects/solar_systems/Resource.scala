package spacemule.modules.pmg.objects.solar_systems

import spacemule.modules.pmg.objects.SolarSystem
import spacemule.modules.config.objects.Config

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 8:24:17 PM
 * To change this template use File | Settings | File Templates.
 */

class Resource extends SolarSystem with PlanetGuardians {
  val planetGuardians = Config.regularPlanetGroundUnits
}