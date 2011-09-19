package spacemule.modules.pmg.persistence.objects

import java.util.Calendar
import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config
import spacemule.persistence.DB

object CallbackRow {
  val columns = "`class`, `object_id`, `event`, `ends_at`, `ruleset`"

  object Events extends Enumeration {
    type Event = Value
    
    /**
     * Scheduled check for inactive player.
     */
    val CheckInactivePlayer = Value(8, "check inactive player")
    /**
     * Spawn something in object.
     */
    val Spawn = Value(9, "spawn")
    /**
     * Spawns metal for creds system offer in the market.
     */
    val CreateMetalSystemOffer = Value(12, "create metal system offer")
    /**
     * Spawns energy for creds system offer in the market.
     */
    val CreateEnergySystemOffer = Value(13, "create energy system offer")
    /**
     * Spawns zetium for creds system offer in the market.
     */
    val CreateZetiumSystemOffer = Value(14, "create zetium system offer")
  }

  private var _playerInactivityCheck: String = null
  def playerInactivityCheck = _playerInactivityCheck
  def initPlayerInactivityCheck = _playerInactivityCheck = DB.date(
    Config.playerInactivityCheck.fromNow)

  private var _asteroidSpawn: String = null
  def asteroidSpawn = _asteroidSpawn
  def initAsteroidSpawn = _asteroidSpawn = DB.date(
    Config.asteroidFirstSpawnCooldown.fromNow)

  private var _convoySpawn: String = null
  def convoySpawn = _convoySpawn
  def initConvoySpawn = _convoySpawn = DB.date(Config.convoyTime.fromNow)

  private var _ssUnitsSpawn: Calendar = null
  def ssUnitsSpawn = _ssUnitsSpawn
  def initSsUnitsSpawn = _ssUnitsSpawn = {
    // Spawn units in pulsars immediately
    Calendar.getInstance
  }
}

case class CallbackRow(
  row: {def id: Int}, 
  ruleset: String, 
  event: Option[CallbackRow.Events.Event] = None,
  time: Option[Calendar] = None
) {
  val values = "%s\t%d\t%d\t%s\t%s".format(
    row match {
      case galaxy: GalaxyRow => "Galaxy"
      case asteroid: SSObjectRow => "SsObject::Asteroid"
      case ssRow: SolarSystemRow => "SolarSystem"
    },
    row.id,
    event match {
      case Some(e) => e.id
      case None => row match {
        case galaxy: GalaxyRow => CallbackRow.Events.Spawn.id
        case asteroid: SSObjectRow => CallbackRow.Events.Spawn.id
        case ssRow: SolarSystemRow => CallbackRow.Events.CheckInactivePlayer.id
      }
    },
    time match {
      case Some(calendar) => DB.date(calendar)
      case None => row match {
        case galaxy: GalaxyRow => CallbackRow.convoySpawn
        case asteroid: SSObjectRow => CallbackRow.asteroidSpawn
        case ssRow: SolarSystemRow => CallbackRow.playerInactivityCheck
      }
    },
    ruleset
  )
}
