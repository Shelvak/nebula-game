package spacemule.modules.pmg.persistence.objects

import java.util.Calendar
import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config
import spacemule.persistence.{DB, RowObject, Row}
import ss_object.{PlanetRow, AsteroidRow}

object CallbackRow extends RowObject {
  val columnsSeq = List("class", "object_id", "event", "ends_at", "ruleset")

  object Events extends Enumeration {
    type Event = Value
    
    /**
     * Planetary raid.
     */
    val Raid = Value(7, "planet raid")
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

  private var _playerInactivityCheck: Calendar = null
  def playerInactivityCheck = _playerInactivityCheck
  def initPlayerInactivityCheck = _playerInactivityCheck =
    Config.playerInactivityCheck.fromNow

  private var _asteroidSpawn: Calendar = null
  def asteroidSpawn = _asteroidSpawn
  def initAsteroidSpawn = _asteroidSpawn =
    Config.asteroidFirstSpawnCooldown.fromNow

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
  event: CallbackRow.Events.Event,
  time: Calendar
) extends Row {
  val companion = CallbackRow

  val valuesSeq = Seq[Any](
    row match {
      case galaxy: GalaxyRow => "Galaxy"
      case aRow: AsteroidRow => "SsObject::Asteroid"
      case pRow: PlanetRow => "SsObject::Planet"
      case ssRow: SolarSystemRow => "SolarSystem"
    },
    row.id,
    event.id,
    DB.date(time),
    ruleset
  )
}
