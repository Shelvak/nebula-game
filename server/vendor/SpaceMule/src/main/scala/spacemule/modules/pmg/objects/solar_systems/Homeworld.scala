package spacemule.modules.pmg.objects.solar_systems

import spacemule.modules.pmg.objects._
import spacemule.modules.config.objects.Config

class Homeworld
extends SolarSystem(Config.homeworldSsConfig) {
  override def toString = "<Homeworld "+super.toString+">"
  override val kind = SolarSystem.Pooled
}