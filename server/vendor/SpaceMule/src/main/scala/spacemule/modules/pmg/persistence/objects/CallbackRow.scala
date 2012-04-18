package spacemule.modules.pmg.persistence.objects

import java.util.Calendar
import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config
import ss_object.{PlanetRow, AsteroidRow}
import spacemule.persistence.{ReferableRow, DB, RowObject, Row}

object CallbackRow extends RowObject {
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
  
  val columnsSeq = List(
    "event", "ends_at", "ruleset",
    "galaxy_id", "ss_object_id", "solar_system_id", "player_id"
  )
}

case class CallbackRow(
  row: ReferableRow,
  ruleset: String, 
  event: CallbackRow.Events.Event,
  time: Calendar
) extends Row {
  val companion = CallbackRow

  lazy val valuesSeq = Seq[Any](
    event.id,
    DB.date(time),
    ruleset,
    if (row.isInstanceOf[GalaxyRow]) row.id else DB.loadInFileNull,
    if (row.isInstanceOf[AsteroidRow] || row.isInstanceOf[PlanetRow])
      row.id else DB.loadInFileNull,
    if (row.isInstanceOf[SolarSystemRow]) row.id else DB.loadInFileNull,
    if (row.isInstanceOf[PlayerRow]) row.id else DB.loadInFileNull
  )
}
