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

  /**
   * Return tile counts for each area tile type.
   */
  def tileCounts(unusedCount: Int): HashMap[AreaTile, AreaTileConfig] = {
    val tileCounts = HashMap[AreaTile, AreaTileConfig]()

    // Get numbers from random ranges for each type
    val proportions = HashMap[AreaTile, Int]()
    var totalProportion = 0

    types.foreach { areaTile =>
      val config = Config.planetAreaTileConfig(areaTile)
      // At this time #count is proportion count.
      proportions(areaTile) = config.count
      totalProportion += config.count

      // Store config with isle count for now.
      tileCounts(areaTile) = config
    }

    proportions.foreach { case (areaTile, proportion) =>
      // Store actual tile count instead of proportion.
      tileCounts(areaTile).count = (
        proportion.toDouble / totalProportion * unusedCount
      ).floor.toInt
    }

    return tileCounts
  }
}

case class AreaTile(kind: Int) extends Tile