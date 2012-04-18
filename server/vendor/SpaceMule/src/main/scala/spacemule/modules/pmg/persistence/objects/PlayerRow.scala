/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.persistence.objects

import java.util.regex.Pattern
import spacemule.modules.pmg.objects.Player
import spacemule.modules.config.objects.Config
import java.util.Calendar
import spacemule.persistence._

object PlayerRow extends RowObject with ReferableRowObject {
  val pkColumn = "id"
  val columnsSeq = Seq(
    "galaxy_id", "web_user_id", "name", "population_cap",
    "planets_count", "created_at"
  )
  val escapeRegexp = Pattern.compile("[\t\n\\\\]")
}

case class PlayerRow(galaxyId: Int, player: Player)
extends Row with ReferableRow {
  val companion = PlayerRow
  
  val valuesSeq = Seq(
    galaxyId,
    player.webUserId,
    escape(player.name),
    Config.startingPopulationMax,
    1,
    DB.date(Calendar.getInstance())
  )

  private def escape(str: String) = PlayerRow.escapeRegexp.matcher(str)
    .replaceAll("")
}