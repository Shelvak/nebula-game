package spacemule.modules.pmg.objects.planet.tiles

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 14, 2010
 * Time: 5:41:14 PM
 * To change this template use File | Settings | File Templates.
 */

import spacemule.modules.pmg.objects.planet.Tile

object BlockTile {
  val Ore = BlockTile(0, 2, 2)
  val Geothermal = BlockTile(1, 2, 2)
  val Zetium = BlockTile(2, 2, 2)
  val Folliage2X3 = BlockTile(15, 2, 3)
  val Folliage2X4 = BlockTile(16, 2, 4)
  val Folliage3X2 = BlockTile(17, 3, 2)
  val Folliage3X3 = BlockTile(8, 3, 3)
  val Folliage3X4 = BlockTile(14, 3, 4)
  val Folliage4X3 = BlockTile(9, 4, 3)
  val Folliage4X4 = BlockTile(10, 4, 4)
  val Folliage4X6 = BlockTile(11, 4, 6)
  val Folliage6X6 = BlockTile(12, 6, 6)
  val Folliage6X2 = BlockTile(13, 6, 2)

  // Order matters here, biggest to smallest.
  val folliageTypes = List[BlockTile](
    Folliage6X6, Folliage4X6, Folliage4X4, Folliage6X2,
    Folliage4X3, Folliage3X4, Folliage3X3, Folliage3X2,
    Folliage2X4, Folliage2X3
  )
  val resourceTypes = List[BlockTile](Ore, Geothermal, Zetium)
}

case class BlockTile(override val kind: Int, width: Int, height: Int)
extends Tile(kind)