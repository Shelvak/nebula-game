/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.objects.ss_objects

import scala.collection.mutable.HashSet
import scala.collection.mutable.ListBuffer
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.classes.geom.area.Area
import spacemule.modules.pmg.classes.geom.area.AreaMap
import spacemule.modules.pmg.objects.planet.Building
import spacemule.modules.pmg.objects.planet.Folliage

trait TerrainFeatures {
  val area: Area
  // Make this lazy to prevent NPE from early initialization.
  lazy protected val tilesMap = new AreaMap(area)
  protected val buildings = ListBuffer[Building]()
  // Building occupied tiles. Used in populating free are with folliage.
  protected val buildingTiles = HashSet[Coords]()
  protected val folliages = ListBuffer[Folliage]()

  protected def initializeTerrain()
}
