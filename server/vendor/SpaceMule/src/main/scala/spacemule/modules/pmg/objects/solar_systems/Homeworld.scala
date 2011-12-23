package spacemule.modules.pmg.objects.solar_systems

import spacemule.modules.pmg.objects._
import spacemule.modules.config.objects.Config

class Homeworld(val player: Player)
extends SolarSystem(Config.homeworldSsConfig) {
  override val shielded = true
}