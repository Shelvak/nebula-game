package spacemule.modules.pmg.classes

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 17, 2010
 * Time: 6:27:54 PM
 * To change this template use File | Settings | File Templates.
 */

object UnitChance {
  def apply(minImportance: Int, chance: Int, name: String, flank: Int) =
    new UnitChance(minImportance, chance, name, flank)
}

class UnitChance(override val minImportance: Int,
                      override val chance: Int,
                      override val name: String, val flank: Int
        ) extends ObjectChance(minImportance, chance, name) {

}