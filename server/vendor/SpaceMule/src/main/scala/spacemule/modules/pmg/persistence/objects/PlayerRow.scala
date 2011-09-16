/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.persistence.objects

import java.util.regex.Pattern
import spacemule.modules.pmg.objects.Player
import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.config.objects.Config

object PlayerRow {
  val columns = "`id`, `galaxy_id`, `web_user_id`, `name`, `scientists`, " +
    "`scientists_total`, `population_cap`, `planets_count`"
  val escapeRegexp = Pattern.compile("[\t\n\\\\]")
}

case class PlayerRow(galaxyId: Int, player: Player) {
  val id = TableIds.player.next
  val values = "%d\t%d\t%d\t%s\t%d\t%d\t%d\t%d".format(
    id,
    galaxyId,
    player.webUserId,
    escape(player.name),
    Config.startingScientists,
    Config.startingScientists,
    Config.startingPopulationMax,
    1
  )

  private def escape(str: String) = PlayerRow.escapeRegexp.matcher(str)
    .replaceAll("")
}