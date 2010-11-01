/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.objects.ss_objects

import spacemule.modules.config.objects.Config

class HomeJumpgate extends Jumpgate {
  override def importance = Config.homeworldJumpgateImportance
}
