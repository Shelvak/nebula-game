package spacemule.modules.pmg.classes

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 17, 2010
 * Time: 6:27:54 PM
 * To change this template use File | Settings | File Templates.
 */

import spacemule.helpers.Random

object UnitChance {
  def apply(minImportance: Int, chance: Int, name: String, flank: Int) =
    new UnitChance(minImportance, chance, name, flank)


  def foreachByChance(chances: Seq[UnitChance], importance: Int)(
               block: (String, Int) => Unit) = {
    chances.foreach { chance =>
      if (importance >= chance.minImportance &&
          Random.boolean(chance.chance)) block(chance.name, chance.flank)
    }
  }
}

class UnitChance(
  val minImportance: Int,
  override val chance: Int,
  override val name: String, val flank: Int
) extends ObjectChance(chance, name) {

}