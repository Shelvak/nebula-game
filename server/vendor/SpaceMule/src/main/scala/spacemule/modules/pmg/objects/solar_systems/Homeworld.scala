package spacemule.modules.pmg.objects.solar_systems

import spacemule.modules.pmg.objects._
import spacemule.modules.config.objects.Config

class Homeworld(val player: Player) extends SolarSystem with FixedMap {
  override val shielded = true
  val map = Config.homeworldSsConfig

  override def groundUnits(obj: SSObject) = Nil
}