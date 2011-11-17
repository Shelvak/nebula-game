package spacemule.modules.pmg.persistence.objects.ss_object

import spacemule.modules.pmg.persistence.Manager
import spacemule.modules.pmg.persistence.TableIds
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.ss_objects._
import spacemule.helpers.Converters._
import spacemule.modules.pmg.objects.SSObject
import spacemule.modules.config.objects.Config
import spacemule.persistence.DB
import spacemule.modules.pmg.persistence.objects.{SSObjectRow, SolarSystemRow}
import java.util.Calendar
import spacemule.modules.pmg.persistence.objects.SSObjectRow.Resources._
import spacemule.modules.pmg.persistence.objects.SSObjectRow.Resources

case class PlanetRow(
  solarSystemRow: SolarSystemRow, coord: Coords, planet: Planet
) extends SSObjectRow(solarSystemRow, coord, planet) {
  override val width = planet.area.width
  override val height = planet.area.height
  override val size = {
    val areaPercentage = planet.area.edgeSum * 100 / Config.planetAreaMax
    val range = Config.ssObjectSize
    range.start + (range.end - range.start) * areaPercentage / 100
  }
  override val terrain = planet.terrainType
  override val playerId = planet match {
    case h: Homeworld => solarSystemRow.playerRow.get.id.toString
    case _ => DB.loadInFileNull
  }
  override val name = planet match {
    case bgPlanet: MiniBgPlanet => "%s-%d".format(
        BgPlanet.Names.wrapped(bgPlanet.index),
        id
    )
    case bgPlanet: BgPlanet => BgPlanet.Names.wrapped(bgPlanet.index)
    case planet: Planet => "P-%d".format(id)
  }

  private val Now = Some(Calendar.getInstance())

  override val ownerChanged = planet match {
    case hw: Homeworld => Now
    case _ => None
  }

  override val resources = planet match {
    case homeworld: Homeworld => Resources(
      Resources.Resource(
        Config.homeworldStartingMetal,
        homeworld.metalGenerationRate,
        homeworld.metalUsageRate,
        homeworld.metalStorage
      ),
      Resources.Resource(
        Config.homeworldStartingEnergy,
        homeworld.energyGenerationRate,
        homeworld.energyUsageRate,
        homeworld.energyStorage
      ),
      Resources.Resource(
        Config.homeworldStartingZetium,
        homeworld.zetiumGenerationRate,
        homeworld.zetiumUsageRate,
        homeworld.zetiumStorage
      ),
      Now
    )
    case p: Planet => Resources(
      Resources.Resource(
        0,
        p.metalGenerationRate,
        p.metalUsageRate,
        p.metalStorage
      ),
      Resources.Resource(
        0,
        p.energyGenerationRate,
        p.energyUsageRate,
        p.energyStorage
      ),
      Resources.Resource(
        0,
        p.zetiumGenerationRate,
        p.zetiumUsageRate,
        p.zetiumStorage
      ),
      Now
    )
  }
}