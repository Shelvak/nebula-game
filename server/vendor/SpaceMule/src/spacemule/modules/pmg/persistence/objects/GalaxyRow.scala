/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds

object GalaxyRow {
  val columns = "`id`, `ruleset`, `callback_url`, `created_at`"
}

class GalaxyRow(ruleset: String, callbackUrl: String, createdAt: String) {
  val id = TableIds.galaxy.next
  val values = (
    "%d\t%s\t%s\t%s".format(
      id,
      ruleset,
      callbackUrl,
      createdAt
    )
  )
}
