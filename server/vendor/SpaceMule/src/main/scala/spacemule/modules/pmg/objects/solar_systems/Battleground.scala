package spacemule.modules.pmg.objects.solar_systems

import spacemule.modules.pmg.objects.SolarSystem
import spacemule.modules.config.objects.Config

/**
 * Solar system in which most battles happen.
 */
class Battleground extends SolarSystem with FixedMap with PlanetGuardians {
  val map = Config.battlegroundSsConfig
  val planetGuardians = Config.battlegroundPlanetGroundUnits
}
