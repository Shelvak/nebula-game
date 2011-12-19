package spacemule.modules.pmg.objects.planet

import tiles.{AreaTile, BlockTile}


/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 16, 2010
 * Time: 8:57:05 PM
 * To change this template use File | Settings | File Templates.
 */

object Tile {
  def apply(kind: Int) = {
    kind match {
      case AreaTile.Regular.kind => AreaTile.Regular
      case AreaTile.Noxrium.kind => AreaTile.Noxrium
      case AreaTile.Junkyard.kind => AreaTile.Junkyard
      case AreaTile.Sand.kind => AreaTile.Sand
      case AreaTile.Titan.kind => AreaTile.Titan
      case BlockTile.Ore.kind => BlockTile.Ore
      case BlockTile.Geothermal.kind => BlockTile.Geothermal
      case BlockTile.Zetium.kind => BlockTile.Zetium
      case BlockTile.Folliage3X3.kind => BlockTile.Folliage3X3
      case BlockTile.Folliage3X4.kind => BlockTile.Folliage3X4
      case BlockTile.Folliage4X3.kind => BlockTile.Folliage4X3
      case BlockTile.Folliage4X4.kind => BlockTile.Folliage4X4
      case BlockTile.Folliage4X6.kind => BlockTile.Folliage4X6
      case BlockTile.Folliage6X6.kind => BlockTile.Folliage6X6
      case BlockTile.Folliage6X2.kind => BlockTile.Folliage6X2
    }
  }
}

abstract class Tile(val kind: Int)