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

object Asteroid {
  object Kind extends Enumeration {
    val Regular = Value("regular")
    val Rich = Value("rich")
  }
  
  def apply(kind: Kind.Value) = new Asteroid(
    Config.asteroidMetalRate(kind),
    Config.asteroidEnergyRate(kind),
    Config.asteroidZetiumRate(kind)
  )
}

class Asteroid(
  val metalRate: Double, val energyRate: Double, val zetiumRate: Double
) extends SSObject {
  val name = "Asteroid"
}