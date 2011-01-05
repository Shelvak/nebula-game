package spacemule.modules.pmg.objects.planet.buildings

import spacemule.modules.pmg.objects.planet.Building
import spacemule.modules.pmg.objects.Unit
import spacemule.modules.pmg.classes.{UnitChance, ObjectChance}
import spacemule.modules.config.objects.Config

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 16, 2010
 * Time: 2:55:27 PM
 * To change this template use File | Settings | File Templates.
 */

class Npc(name: String, x: Int, y: Int) extends Building(name, x, y) {
  override val importance = Config.npcBuildingImportance(this)

  def createUnits(chances: List[UnitChance]) {
    ObjectChance.foreachByChance(chances, importance) {
      chance =>

      units += Unit(chance.name, chance.asInstanceOf[UnitChance].flank)
    }
  }
}