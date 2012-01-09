/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.persistence.objects

import java.util.regex.Pattern
import spacemule.modules.pmg.objects.Player
import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.config.objects.Config
import java.util.Calendar
import spacemule.persistence.{DB, Row, RowObject}

object PlayerRow extends RowObject {
  val columnsSeq = Seq(
    "id", "galaxy_id", "web_user_id", "name", "scientists",
    "scientists_total", "population_cap", "planets_count", "created_at"
  )
  val escapeRegexp = Pattern.compile("[\t\n\\\\]")
}

case class PlayerRow(galaxyId: Int, player: Player) extends Row {
  val companion = PlayerRow
  
  val id = TableIds.player.next
  val valuesSeq = Seq(
    id,
    galaxyId,
    player.webUserId,
    escape(player.name),
    Config.startingScientists,
    Config.startingScientists,
    Config.startingPopulationMax,
    1,
    DB.date(Calendar.getInstance())
  )

  private def escape(str: String) = PlayerRow.escapeRegexp.matcher(str)
    .replaceAll("")
}