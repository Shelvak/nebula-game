package spacemule.modules.pmg.objects.ss_objects

import spacemule.modules.pmg.objects.SSObject
import spacemule.modules.config.objects.Config

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 9:08:40 PM
 * To change this template use File | Settings | File Templates.
 */

class Jumpgate extends SSObject {
  def importance = Config.jumpgateImportance
}