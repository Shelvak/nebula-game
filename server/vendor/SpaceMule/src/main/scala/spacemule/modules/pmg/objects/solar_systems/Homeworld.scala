package spacemule.modules.pmg.objects.solar_systems

import spacemule.helpers.Converters._
import spacemule.modules.pmg.objects._
import spacemule.modules.config.objects.{SsConfig, Config}
import spacemule.modules.pmg.classes.geom.Coords
import ss_objects.{Asteroid, Planet, Jumpgate, Nothing}

class Homeworld(val player: Player) extends SolarSystem {
  override val shielded = true

  override def createObjectsImpl() {
    Config.homeworldSsConfig.foreach { case(coords, entry) =>
      entry match {
        case e: SsConfig.PlanetEntry => createPlanet(coords, e)
        case e: SsConfig.AsteroidEntry => createAsteroid(coords, e)
        case e: SsConfig.JumpgateEntry => createObject(new Jumpgate, coords, e)
        case e: SsConfig.NothingEntry => createObject(new Nothing, coords, e)
      }
    }
  }

  private[this] def createPlanet(
    coords: Coords, entry: SsConfig.PlanetEntry
  ) {
  }

  private[this] def createAsteroid(
    coords: Coords, entry: SsConfig.AsteroidEntry
  ) {
    createObject(
      new Asteroid(
        entry.resources.metal, entry.resources.energy, entry.resources.zetium
      ),
      coords, entry
    )
  }

  private[this] def createObject(
    obj: SSObject, coords: Coords, entry: SsConfig.Entry
  ) = {
    objects(coords) = obj
    
    if (entry.units.isDefined) obj.createOrbitUnits(entry.units.get)
    obj.wreckage = entry.wreckage

    obj
  }
}