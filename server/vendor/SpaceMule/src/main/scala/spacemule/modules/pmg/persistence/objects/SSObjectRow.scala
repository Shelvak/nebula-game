package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.ss_objects._
import spacemule.helpers.Converters._
import spacemule.modules.pmg.objects.SSObject
import spacemule.modules.config.objects.Config
import spacemule.persistence.{DB, RowObject, Row}
import java.util.Calendar
import ss_object._

object SSObjectRow extends RowObject {
  val columnsSeq = List(
    "id", "type", "solar_system_id", "angle", "position", "width", "height",
    "terrain", "player_id", "name", "size", "owner_changed",
    "metal", "metal_generation_rate", "metal_usage_rate", "metal_storage",
    "energy", "energy_generation_rate", "energy_usage_rate", "energy_storage",
    "zetium", "zetium_generation_rate", "zetium_usage_rate", "zetium_storage",
    "last_resources_update"
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
  solarSystemRow: SolarSystemRow, coord: Coords, ssObject: SSObject
) extends Row {
  val companion = SSObjectRow
  val id = TableIds.ssObject.next
  val width = 0
  val height = 0
  val size = Config.ssObjectSize.random
  val terrain = 0
  val playerId = DB.loadInFileNull
  val name = DB.loadInFileNull
  val resources = SSObjectRow.Resources(
    SSObjectRow.Resources.Resource(0, 0, 0, 0),
    SSObjectRow.Resources.Resource(0, 0, 0, 0),
    SSObjectRow.Resources.Resource(0, 0, 0, 0)
  )
  val ownerChanged: Option[Calendar] = None

  // Initialize this lazily, because this abstract class is subclassed.
  lazy val valuesSeq = List(
    id, ssObject.name, solarSystemRow.id, coord.angle, coord.position,
    width, height, terrain, playerId, name, size, DB.date(ownerChanged)
  ) ++ resources.toSeq
}