package spacemule.modules.pmg.objects.ss_objects

import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config

object MiniBgPlanet {
  lazy val Maps = Config.battlegroundPlanetMaps.map {
    map => MapReader.parseMap(map, Nil) }
}

class MiniBgPlanet(override val index: Int) extends BgPlanet(index) {
  override protected def data = MiniBgPlanet.Maps(index)
}
