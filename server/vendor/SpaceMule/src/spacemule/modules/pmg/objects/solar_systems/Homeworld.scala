package spacemule.modules.pmg.objects.solar_systems

import spacemule.modules.pmg.objects._
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.objects.ss_objects.Asteroid
import spacemule.modules.pmg.objects.ss_objects.Jumpgate
import spacemule.modules.pmg.objects.ss_objects.Planet
import spacemule.modules.pmg.objects.ss_objects.RichAsteroid

object Homeworld {
  /**
   * Terrains for non homeworld planets in homeworld solar systems.
   */
  val NonHomeworldTerrains = (
    Planet.terrains.toBuffer - Planet.TerrainEarth
  ).toSeq
}

class Homeworld(val player: Player) extends SolarSystem {
  override val shielded = true

  if (planetCount + 1 > orbitCount) {
    throw new Exception(
      "Planet count %d is more than orbit count %d for Homeworld ss!".format(
      planetCount + 1, orbitCount))
  }

  override def createPlanets() = {
    createObjectType(1) { () => new ss_objects.Homeworld() }
    createObjectType(planetCount) { () =>
      new Planet(
        Config.homeSolarSystemPlanetsArea,
        Homeworld.NonHomeworldTerrains
      )
    }
  }

  override protected def orbitUnits(obj: SSObject) = obj match {
    case homeworld: ss_objects.Homeworld => List()
    case planet: Planet => Config.homeworldPlanetUnits
    case asteroid: RichAsteroid => Config.homeworldRichAsteroidUnits
    case asteroid: Asteroid => Config.homeworldAsteroidUnits
    case jumpgate: Jumpgate => Config.homeworldJumpgateUnits
  }
}