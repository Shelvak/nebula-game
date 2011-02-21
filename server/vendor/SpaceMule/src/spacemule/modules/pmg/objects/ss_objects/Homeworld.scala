package spacemule.modules.pmg.objects.ss_objects

import spacemule.modules.pmg.objects.Player
import spacemule.modules.pmg.objects.planet._
import spacemule.modules.config.objects.Config

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 14, 2010
 * Time: 12:08:02 PM
 * To change this template use File | Settings | File Templates.
 */

object Homeworld {
  lazy val data = MapReader.parseMap(Config.homeworldMap,
                                     Config.npcHomeworldBuildingUnitChances)
}

class Homeworld(val player: Player) extends Planet with PresetMap {
  override def importance = 0
  override val terrainType = Planet.TerrainEarth
  override protected def data = Homeworld.data
}