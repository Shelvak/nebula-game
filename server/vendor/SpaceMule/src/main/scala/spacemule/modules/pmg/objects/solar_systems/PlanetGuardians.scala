package spacemule.modules.pmg.objects.solar_systems

import spacemule.modules.pmg.objects.{SSObject, SolarSystem}
import spacemule.modules.pmg.objects.ss_objects.Planet
import spacemule.modules.config.objects.{UnitsEntry, Config}


/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 12/21/11
 * Time: 2:04 PM
 * To change this template use File | Settings | File Templates.
 */

/**
 * Mix this in if you want planet guardians.
 */
trait PlanetGuardians { this: SolarSystem =>
  val planetGuardians: Seq[UnitsEntry]
  
  override protected def groundUnits(obj: SSObject): Seq[UnitsEntry] =
    obj match {
      case planet: Planet => planetGuardians
      case _ => Seq.empty
    }
}