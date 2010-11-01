package spacemule.modules.pmg.classes.geom.area

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 14, 2010
 * Time: 12:11:39 PM
 * To change this template use File | Settings | File Templates.
 */

object Area {
  def proportional(area: Int, proportion: Double): Area = {
    val width = (area * proportion).round.toInt
    val height = (area * (1 - proportion)).round.toInt
    return Area(width, height)
  }
}

case class Area(width: Int, height: Int) {
  val area = width * height
  val edgeSum = width + height
}