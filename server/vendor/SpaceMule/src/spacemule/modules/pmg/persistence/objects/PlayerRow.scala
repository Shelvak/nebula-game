/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.persistence.objects

import java.util.regex.Pattern
import spacemule.modules.pmg.objects.Galaxy
import spacemule.modules.pmg.objects.Player
import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.config.objects.Config

object PlayerRow {
  val columns = "`id`, `galaxy_id`, `auth_token`, `name`, `scientists`, " +
    "`scientists_total`"
  val escapeRegexp = Pattern.compile("[\t\n\\\\]")
}

case class PlayerRow(galaxy: Galaxy, player: Player) {
  val id = TableIds.player.next
  val values = "%d\t%d\t%s\t%s\t%d\t%d".format(
    id,
    galaxy.id,
    escape(player.authToken),
    escape(player.name),
    Config.homeworldStartingScientists,
    Config.homeworldStartingScientists
  )

  private def escape(str: String) = PlayerRow.escapeRegexp.matcher(str)
    .replaceAll("")
}