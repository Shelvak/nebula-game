package spacemule.modules.pmg.persistence.objects

import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.objects.ss_objects.Asteroid
import spacemule.persistence.DB

object CallbackRow {
  val columns = "`class`, `object_id`, `event`, `ends_at`, `ruleset`"

  /**
   * Scheduled check for inactive player.
   */
  val EventCheckInactivePlayer = 8
  /**
   * Spawn something in object.
   */
  val EventSpawn = 9

  private var _playerInactivityCheck: String = null
  def playerInactivityCheck = _playerInactivityCheck
  def initPlayerInactivityCheck = _playerInactivityCheck = DB.date(
    Config.playerInactivityCheck.fromNow)

  private var _asteroidSpawn: String = null
  def asteroidSpawn = _asteroidSpawn
  def initAsteroidSpawn = _asteroidSpawn = DB.date(
    Config.asteroidFirstSpawnCooldown.fromNow)
}

case class CallbackRow(row: {def id: Int}, ruleset: String) {
  val values = "%s\t%d\t%d\t%s\t%s".format(
    row match {
      case asteroid: SSObjectRow => "SsObject::Asteroid"
      case ssRow: SolarSystemRow => "SolarSystem"
    },
    row.id,
    row match {
      case asteroid: SSObjectRow => CallbackRow.EventSpawn
      case ssRow: SolarSystemRow => CallbackRow.EventCheckInactivePlayer
    },
    row match {
      case asteroid: SSObjectRow => CallbackRow.asteroidSpawn
      case ssRow: SolarSystemRow => CallbackRow.playerInactivityCheck
    },
    ruleset
  )
}
