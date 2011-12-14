/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.objects.ss_objects

import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config

object BgPlanet {
  lazy val Maps = Config.battlegroundPlanetMaps.map {
    map => MapReader.parseMap(map, Nil, Config.battlegroundBuildingMaxLevel) }

  val Names = List("Gramen", "Inculta", "Limus")
}

/**
 * Battleground planet with preset map.
 */
class BgPlanet(val index: Int)
extends Planet(Config.planetArea, Planet.terrains.wrapped(index))
with PresetMap {
  override protected def data = BgPlanet.Maps(index)
}
