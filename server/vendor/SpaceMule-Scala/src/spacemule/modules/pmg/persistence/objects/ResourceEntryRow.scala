package spacemule.modules.pmg.persistence.objects

import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.objects.SSObject
import spacemule.modules.pmg.objects.solar_systems.Homeworld
import spacemule.modules.pmg.objects.ss_objects.Asteroid
import spacemule.modules.pmg.objects.ss_objects.Planet

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 18, 2010
 * Time: 6:21:41 PM
 * To change this template use File | Settings | File Templates.
 */

object ResourceEntryRow {
  val columns = "`planet_id`, `metal`, `metal_rate`, `metal_storage`, " +
          "`energy`, `energy_rate`, `energy_storage`, " +
          "`zetium`, `zetium_rate`, `zetium_storage`"
}

case class ResourceEntryRow(ssoRow: SSObjectRow, obj: SSObject) {
  val values = obj match {
    case asteroid: Asteroid => {
      "(%d, %d, %d, %f, %d, %d, %f, %d, %d, %f)".format(
        ssoRow.id,
        0, 0, asteroid.metalStorage,
        0, 0, asteroid.energyStorage,
        0, 0, asteroid.zetiumStorage
      )
    }
    case homeworld: Homeworld => {
      "(%d, %f, %f, %f, %f, %f, %f, %f, %f, %f)".format(
        ssoRow.id,
        Config.homeworldStartingMetal,
        Config.homeworldStartingMetalRate,
        Config.homeworldStartingMetalStorage,
        Config.homeworldStartingEnergy,
        Config.homeworldStartingEnergyRate,
        Config.homeworldStartingEnergyStorage,
        Config.homeworldStartingZetium,
        Config.homeworldStartingZetiumRate,
        Config.homeworldStartingZetiumStorage
      )
    }
    case planet: Planet => {
      "(%d, %d, %d, %d, %d, %d, %d, %d, %d, %d)".format(
        ssoRow.id,
        0, 0, 0,
        0, 0, 0,
        0, 0, 0
      )
    }
  }
}