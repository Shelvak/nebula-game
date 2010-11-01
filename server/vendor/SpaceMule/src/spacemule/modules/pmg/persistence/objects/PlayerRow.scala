/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.persistence.objects

import com.mysql.jdbc.PreparedStatement
import java.util.regex.Pattern
import spacemule.modules.pmg.objects.Galaxy
import spacemule.modules.pmg.objects.Player
import spacemule.modules.pmg.persistence.TableIds

object PlayerRow {
  val columns = "`id`, `galaxy_id`, `auth_token`, `name`"
  val escapeRegexp = Pattern.compile("[\t\n\\\\]")
}

case class PlayerRow(galaxy: Galaxy, player: Player) {
  val id = TableIds.player.next
  val values = "%d\t%d\t%s\t%s".format(
    id,
    galaxy.id,
    escape(player.authToken),
    escape(player.name)
  )

  private def escape(str: String) = PlayerRow.escapeRegexp.matcher(str)
    .replaceAll("")
}