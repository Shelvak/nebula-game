/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.persistence.objects

import scala.collection.Set

case class SaveResult(val updatedPlayerIds: Set[Int],
                      val updatedAllianceIds: Set[Int])