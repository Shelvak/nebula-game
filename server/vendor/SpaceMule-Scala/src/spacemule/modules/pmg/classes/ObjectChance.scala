package spacemule.modules.pmg.classes

import spacemule.helpers.Random


/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 15, 2010
 * Time: 12:25:01 PM
 * To change this template use File | Settings | File Templates.
 */

object ObjectChance {
  def foreachByChance(chances: List[ObjectChance], importance: Int)(
               block: (ObjectChance) => Unit) = {
    chances.foreach { chance =>
      if (importance >= chance.minImportance &&
              Random.boolean(chance.chance)) {
        block(chance)
      }
    }
  }
}

case class ObjectChance(minImportance: Int, chance: Int,
                             name: String)