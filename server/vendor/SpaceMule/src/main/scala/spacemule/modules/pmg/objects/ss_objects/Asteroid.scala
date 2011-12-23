package spacemule.modules.pmg.objects.ss_objects

import spacemule.modules.pmg.objects.SSObject
import spacemule.modules.config.objects.Config

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 9:07:24 PM
 * To change this template use File | Settings | File Templates.
 */

class Asteroid(
  val metalRate: Double, val energyRate: Double, val zetiumRate: Double
) extends SSObject {
  val name = "Asteroid"
}