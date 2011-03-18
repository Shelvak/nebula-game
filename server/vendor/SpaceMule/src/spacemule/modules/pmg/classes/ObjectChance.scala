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
  def foreachByChance(chances: List[ObjectChance])(
               block: (String) => Unit) = {
    chances.foreach { chance =>
      if (Random.boolean(chance.chance)) block(chance.name)
    }
  }

  def apply(chance: Int, name: String) = new ObjectChance(chance, name)
}

class ObjectChance(val chance: Int, val name: String)