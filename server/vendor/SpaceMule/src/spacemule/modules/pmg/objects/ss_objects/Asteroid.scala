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

class Asteroid extends SSObject {
  val metalStorage = Config.asteroidMetalRate(this)
  val energyStorage = Config.asteroidEnergyRate(this)
  val zetiumStorage = Config.asteroidZetiumRate(this)

  val name = "Asteroid"
}