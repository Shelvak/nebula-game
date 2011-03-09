package spacemule.modules.pmg.objects.solar_systems

import spacemule.modules.pmg.objects._
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.objects.ss_objects.Planet

object Homeworld {
  /**
   * Terrains for non homeworld planets in homeworld solar systems.
   */
  val NonHomeworldTerrains = (
    Planet.terrains.toBuffer - Planet.TerrainEarth
  ).toSeq
}

class Homeworld(player: Player) extends SolarSystem {
  if (planetCount + 1 > orbitCount) {
    throw new Exception(
      "Planet count %d is more than orbit count %d for Homeworld ss!".format(
      planetCount + 1, orbitCount))
  }

  override def createPlanets() = {
    createObjectType(1) { () => new ss_objects.Homeworld(player) }
    createObjectType(planetCount) { () =>
      new Planet(
        Config.homeSolarSystemPlanetsArea,
        Homeworld.NonHomeworldTerrains
      )
    }
  }

  override def createJumpgates() = {
    createObjectType(jumpgateCount) { () => new ss_objects.HomeJumpgate() }
  }

  override protected def orbitUnits = Config.homeworldOrbitUnits
}