package spacemule.modules.pmg.objects.planet.tiles

import collection.mutable.HashMap
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.classes.geom.area.AreaMap
import spacemule.modules.pmg.classes.geom.area.AreaTileConfig
import spacemule.modules.pmg.objects.planet.Tile

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 15, 2010
 * Time: 2:10:05 PM
 * To change this template use File | Settings | File Templates.
 */

object AreaTile {
  val Regular = AreaTile(AreaMap.DefaultValue)
  val Noxrium = AreaTile(3)
  val Junkyard = AreaTile(4)
  val Sand = AreaTile(5)
  val Titan = AreaTile(6)

  val types = List[AreaTile](Regular, Noxrium, Junkyard, Titan, Sand)
}

case class AreaTile(override val kind: Int) extends Tile(kind)