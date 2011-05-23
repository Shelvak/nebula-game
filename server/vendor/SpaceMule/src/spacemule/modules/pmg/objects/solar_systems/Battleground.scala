package spacemule.modules.pmg.objects.solar_systems

import spacemule.helpers.Converters._
import spacemule.modules.pmg.objects.SSObject
import spacemule.modules.pmg.objects.SolarSystem
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.objects.ss_objects.Asteroid
import spacemule.modules.pmg.objects.ss_objects.BgPlanet
import spacemule.modules.pmg.objects.ss_objects.Jumpgate
import spacemule.modules.pmg.objects.ss_objects.Planet
import spacemule.modules.pmg.objects.ss_objects.RichAsteroid

/**
 * Solar system in which most battles happen.
 */
class Battleground extends SolarSystem {
  override def createPlanets() = {
    Config.battlegroundPlanetPositions.foreachWithIndex {
      case (coords, index) => 
        val planet = new BgPlanet(index)
        planet.createOrbitUnits(orbitUnits(planet))
        initializeAndAdd(planet, coords)
    }
  }

  override def createJumpgates() = {
    Config.battlegroundJumpgatePositions.foreach { coords =>
      initializeAndAdd(new Jumpgate(), coords)
    }
  }

  override protected def orbitUnits(obj: SSObject) = obj match {
    case planet: Planet => Config.battlegroundPlanetUnits
    case asteroid: RichAsteroid => Config.battlegroundRichAsteroidUnits
    case asteroid: Asteroid => Config.battlegroundAsteroidUnits
    case jumpgate: Jumpgate => Config.battlegroundJumpgateUnits
  }
}
