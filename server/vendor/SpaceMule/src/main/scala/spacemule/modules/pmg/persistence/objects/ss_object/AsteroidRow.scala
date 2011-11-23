package spacemule.modules.pmg.persistence.objects.ss_object

import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.persistence.objects.{SSObjectRow, SolarSystemRow}
import SSObjectRow.Resources
import spacemule.modules.pmg.objects.ss_objects.Asteroid

case class AsteroidRow(
  solarSystemRow: SolarSystemRow, coord: Coords, asteroid: Asteroid
) extends SSObjectRow(solarSystemRow, coord, asteroid) {
  override val resources = Resources(
    Resources.Resource(0, asteroid.metalRate, 0, 0),
    Resources.Resource(0, asteroid.energyRate, 0, 0),
    Resources.Resource(0, asteroid.zetiumRate, 0, 0)
  )
}