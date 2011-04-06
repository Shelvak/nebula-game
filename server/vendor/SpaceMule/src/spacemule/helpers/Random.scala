package spacemule.helpers

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 15, 2010
 * Time: 11:33:25 AM
 * To change this template use File | Settings | File Templates.
 */

object Random extends util.Random {
  /**
   * Return true/false based on chance. Chance is a number between 0 and 100.
   */
  def boolean(chance: Int): Boolean = {
    // < because <= adds 1%
    return (nextInt(100) < chance)
  }

  /**
   * Return Boolean based on chance. Chance is a number between 0 and 1.
   */
  def boolean(chance: Double): Boolean = {
    if (chance > 1)
      throw new IllegalArgumentException(
        "chance cannot be > 1, but %3.4f was given!".format(chance))

    boolean((chance * 100).round.toInt)
  }
}