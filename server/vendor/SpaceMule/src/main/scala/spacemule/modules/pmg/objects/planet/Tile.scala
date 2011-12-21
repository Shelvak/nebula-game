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
  def apply(kind: Int): Tile = {
    AreaTile.types.foreach { tile =>
      if (tile.kind == kind) return tile
    }
    BlockTile.resourceTypes.foreach { tile =>
      if (tile.kind == kind) return tile
    }
    BlockTile.folliageTypes.foreach { tile =>
      if (tile.kind == kind) return tile
    }

    throw new MatchError("Unknown tile kind %d!".format(kind))
  }
}

abstract class Tile(val kind: Int)