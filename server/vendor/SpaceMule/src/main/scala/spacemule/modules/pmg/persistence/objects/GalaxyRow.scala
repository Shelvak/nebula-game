/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.persistence.objects

import spacemule.persistence.{Row, RowObject}

object GalaxyRow extends RowObject {
  val pkColumn = Some("id")
  val columnsSeq = List("ruleset", "callback_url", "created_at")
}

class GalaxyRow(
  ruleset: String, callbackUrl: String, createdAt: String
) extends Row {
  val companion = GalaxyRow

  val valuesSeq = List(
    ruleset,
    callbackUrl,
    createdAt
  )
}
