package spacemule.modules.pmg.persistence.objects.ss_object

import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.ss_objects._
import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config
import spacemule.persistence.DB
import spacemule.modules.pmg.persistence.objects.{SSObjectRow, SolarSystemRow}
import java.util.Calendar
import spacemule.modules.pmg.persistence.objects.SSObjectRow.Resources

case class PlanetRow(
  solarSystemRow: SolarSystemRow, coord: Coords, planet: Planet
) extends SSObjectRow(solarSystemRow, coord, planet) {
  override val width = planet.map.area.width
  override val height = planet.map.area.height
  override val size = {
    val areaPercentage = planet.map.area.edgeSum * 100 / Config.planetAreaMax
    val range = Config.ssObjectSize
    range.start + (range.end - range.start) * areaPercentage / 100
  }
  override val terrain = planet.map.terrain
  override val playerId =
    if (planet.ownedByPlayer) solarSystemRow.playerRow.get.id.toString
    else DB.loadInFileNull
  override val name = planet.planetName(id)

  private val Now = Some(Calendar.getInstance())

  override val ownerChanged = if (planet.ownedByPlayer) Now else None
  override val nextRaidAt = Some(planet.nextRaidAt)

  override val resources = planet match {
    case p: Planet => Resources(
      Resources.Resource(
        p.map.resources.metal,
        p.metalGenerationRate,
        p.metalUsageRate,
        p.metalStorage
      ),
      Resources.Resource(
        p.map.resources.energy,
        p.energyGenerationRate,
        p.energyUsageRate,
        p.energyStorage
      ),
      Resources.Resource(
        p.map.resources.zetium,
        p.zetiumGenerationRate,
        p.zetiumUsageRate,
        p.zetiumStorage
      ),
      Now
    )
  }
}