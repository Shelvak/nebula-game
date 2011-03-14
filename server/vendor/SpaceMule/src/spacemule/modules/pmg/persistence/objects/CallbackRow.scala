package spacemule.modules.pmg.persistence.objects

import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config
import spacemule.persistence.DB

object CallbackRow {
  val columns = "`class`, `object_id`, `event`, `ends_at`, `ruleset`"

  /**
   * Scheduled check for inactive player.
   */
  val EventCheckInactivePlayer = 8

  private var _playerInactivityCheck: String = null
  def playerInactivityCheck = _playerInactivityCheck
  def initPlayerInactivityCheck = _playerInactivityCheck = DB.date(
    Config.playerInactivityCheck.fromNow)
}

case class CallbackRow(row: {def id: Int}, ruleset: String) {
  val values = "%s\t%d\t%d\t%s\t%s".format(
    row match {
      case ssRow: SolarSystemRow => "SolarSystem"
    },
    row.id,
    row match {
      case ssRow: SolarSystemRow => CallbackRow.EventCheckInactivePlayer
    },
    row match {
      case ssRow: SolarSystemRow => CallbackRow.playerInactivityCheck
    },
    ruleset
  )
}
