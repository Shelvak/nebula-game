package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.ss_objects._
import spacemule.helpers.Converters._
import spacemule.modules.pmg.objects.SSObject
import spacemule.modules.config.objects.Config
import java.util.Calendar
import ss_object._
import spacemule.persistence._

object SSObjectRow extends RowObject with ReferableRowObject {
  val pkColumn = "id"
  val columnsSeq = List(
    "type", "solar_system_id", "angle", "position", "width", "height",
    "terrain", "player_id", "name", "size", "owner_changed",
    "metal", "metal_generation_rate", "metal_usage_rate", "metal_storage",
    "energy", "energy_generation_rate", "energy_usage_rate", "energy_storage",
    "zetium", "zetium_generation_rate", "zetium_usage_rate", "zetium_storage",
    "last_resources_update", "next_raid_at"
  )

  object Resources {
    case class Resource(
      stock: Double, generationRate: Double, usageRate: Double,
      storage: Double
    ) {
      def toSeq = Seq(stock, generationRate, usageRate, storage)
    }
  }

  case class Resources(
    metal: Resources.Resource,
    energy: Resources.Resource,
    zetium: Resources.Resource,
    lastResourcesUpdate: Option[Calendar] = None
  ) {
    def toSeq = metal.toSeq ++ energy.toSeq ++ zetium.toSeq :+
      (lastResourcesUpdate match {
        case Some(calendar) => DB.date(calendar)
        case None => DB.loadInFileNull
      })
  }

  def apply(
    solarSystemRow: SolarSystemRow, coord: Coords, ssObject: SSObject
  ) = ssObject match {
    case a: Asteroid => AsteroidRow(solarSystemRow, coord, a)
    case p: Planet => PlanetRow(solarSystemRow, coord, p)
    case j: Jumpgate => JumpgateRow(solarSystemRow, coord, j)
  }
}

abstract class SSObjectRow(
  solarSystemRow: SolarSystemRow, coord: Coords,
  ssObject: SSObject
) extends LocationRow {
  val companion = SSObjectRow
  val width = 0
  val height = 0
  val size = Config.ssObjectSize.random
  val terrain = 0
  // Initialize this lazily, to allow subclasses to have lazy eval too.
  lazy val playerId = DB.loadInFileNull
  val name = "" // not null!
  val resources = SSObjectRow.Resources(
    SSObjectRow.Resources.Resource(0, 0, 0, 0),
    SSObjectRow.Resources.Resource(0, 0, 0, 0),
    SSObjectRow.Resources.Resource(0, 0, 0, 0)
  )
  val ownerChanged: Option[Calendar] = None
  val nextRaidAt: Option[Calendar] = None

  protected[this] def valuesImpl = List(
    ssObject.name, solarSystemRow.id, coord.angle, coord.position,
    width, height, terrain, playerId, name, size, DB.date(ownerChanged)
  ) ++ resources.toSeq :+ (nextRaidAt match {
    case Some(time) => DB.date(time)
    case None => DB.loadInFileNull
  })
}