package spacemule.modules.pmg.objects.solar_systems

import scala.util.Random
import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.objects.ss_objects.MiniBgPlanet

class MiniBattleground extends Battleground {
  override def createPlanets() = {
    val coords = Config.battlegroundPlanetPositions.random
    val index = Random.nextInt(Config.battlegroundPlanetPositions.size)
    val planet = new MiniBgPlanet(index)
    planet.createOrbitUnits(orbitUnits(planet))
    initializeAndAdd(planet, coords)
  }
}
