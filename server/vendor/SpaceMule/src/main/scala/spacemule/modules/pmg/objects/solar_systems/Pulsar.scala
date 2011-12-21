package spacemule.modules.pmg.objects.solar_systems

import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.objects.SolarSystem

class Pulsar extends SolarSystem with FixedMap with PlanetGuardians {
  val map = Config.pulsarSsConfig
  val planetGuardians = Config.battlegroundPlanetGroundUnits
}
