package spacemule.modules.pmg.persistence.objects

import java.util.Calendar
import spacemule.helpers.Converters._
import jruby.JRuby._
import spacemule.helpers.JRuby._
import spacemule.modules.config.objects.Config
import ss_object.{PlanetRow, AsteroidRow}
import spacemule.persistence.{ReferableRow, DB, RowObject, Row}

object CallbackRow extends RowObject {
  object Events extends Enumeration {
    private[this] val cm = RClass("CallbackManager")
    private[this] def evt(name: String) =
      cm.getConstant("EVENT_" + name.toUpperCase).asInt

    type Event = Value

    /**
     * Planetary raid.
     */
    val Raid = Value(evt("raid"), "planet raid")
    /**
     * Spawn something in object.
     */
    val Spawn = Value(evt("spawn"), "spawn")
  }

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
    "event", "ends_at", "ruleset", "ss_object_id", "solar_system_id"
  )
}

case class CallbackRow(
  row: ReferableRow,
  ruleset: String, 
  event: CallbackRow.Events.Event,
  time: Calendar
) extends Row {
  val companion = CallbackRow

  protected[this] def valuesImpl = Seq[Any](
    event.id,
    DB.date(time),
    ruleset,
    if (row.isInstanceOf[AsteroidRow] || row.isInstanceOf[PlanetRow])
      row.id else DB.loadInFileNull,
    if (row.isInstanceOf[SolarSystemRow]) row.id else DB.loadInFileNull
  )
}
