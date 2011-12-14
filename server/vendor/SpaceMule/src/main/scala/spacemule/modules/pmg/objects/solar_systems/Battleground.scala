package spacemule.modules.pmg.objects.solar_systems

import spacemule.helpers.Converters._
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.SSObject
import spacemule.modules.pmg.objects.SolarSystem
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.objects.ss_objects.Asteroid
import spacemule.modules.pmg.objects.ss_objects.BgPlanet
import spacemule.modules.pmg.objects.ss_objects.Jumpgate
import spacemule.modules.pmg.objects.ss_objects.Planet

/**
 * Solar system in which most battles happen.
 */
class Battleground extends SolarSystem {
  override def createPlanets() = {
    Config.battlegroundPlanetPositions.foreachWithIndex {
      case (coords, index) => initializeAndAdd(new BgPlanet(index), coords)
    }
  }

  override def createJumpgates() = {
    Config.battlegroundJumpgatePositions.foreach { coords =>
      initializeAndAdd(new Jumpgate(), coords)
    }
  }
  
  override protected def groundUnits(obj: SSObject) = obj match {
    case planet: Planet => Config.battlegroundPlanetGroundUnits
    case _ => super.groundUnits(obj)
  }

  override protected def orbitUnits(obj: SSObject) = obj match {
    case planet: Planet => Config.battlegroundPlanetOrbitUnits
    case asteroid: Asteroid => Config.battlegroundAsteroidOrbitUnits
    case jumpgate: Jumpgate => Config.battlegroundJumpgateOrbitUnits
    case _ => super.orbitUnits(obj)
  }
}
