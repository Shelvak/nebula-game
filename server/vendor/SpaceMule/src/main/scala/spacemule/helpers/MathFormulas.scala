package spacemule.helpers

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 1/12/12
 * Time: 2:55 PM
 * To change this template use File | Settings | File Templates.
 */

object MathFormulas {
  /**
   * Returns a function which can be used to calculate points in given line
   * (which is calculated from two points).
   **/
  def line(x1: Double, y1: Double, x2: Double, y2: Double) = {
    val k = (y1 - y2) / (x1 - x2)
    val c = y2 - k * x2
  
    (x: Double) => k * x + c
  }
}