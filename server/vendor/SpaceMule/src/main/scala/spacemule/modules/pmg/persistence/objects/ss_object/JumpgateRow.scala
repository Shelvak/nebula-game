package spacemule.modules.pmg.persistence.objects.ss_object

import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.persistence.objects.{SSObjectRow, SolarSystemRow}
import SSObjectRow.Resources
import spacemule.modules.pmg.objects.ss_objects.Jumpgate

case class JumpgateRow(
  solarSystemRow: SolarSystemRow, coord: Coords, jumpgate: Jumpgate
) extends SSObjectRow(solarSystemRow, coord, jumpgate)