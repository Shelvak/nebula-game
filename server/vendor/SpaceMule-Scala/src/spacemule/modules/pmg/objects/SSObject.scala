package spacemule.modules.pmg.objects

import scala.collection.mutable.ListBuffer
import spacemule.helpers.Random
import spacemule.modules.pmg.classes.{UnitChance, Chance, ObjectChance}
import spacemule.modules.config.objects.Config

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 9:04:26 PM
 * To change this template use File | Settings | File Templates.
 */

/**
 * A solar system object
 */
trait SSObject {
  /**
   * Internal importance number.
   */
  def importance: Int

  var units = ListBuffer[Unit]()

  /**
   * Provide initialization code here.
   */
  def initialize = {}

  def hasOrbitUnits(chances: List[Chance]): Boolean = {
    val importance = this.importance
    chances.foreach { chance =>
      if (importance >= chance.minImportance) {
        return Random.boolean(chance.chance)
      }
    }

    return false
  }

  def createOrbitUnits(unitChances: List[UnitChance]): scala.Unit = {
    ObjectChance.foreachByChance(unitChances, importance) {
      chance =>

      units += Unit(chance.name, chance.asInstanceOf[UnitChance].flank)
    }
  }
}