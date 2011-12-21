package spacemule.modules.pmg.objects.solar_systems

import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.config.objects.{Config, SsConfig}
import spacemule.modules.pmg.objects.{SolarSystem, SSObject}
import spacemule.modules.pmg.objects.ss_objects._

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 12/21/11
 * Time: 1:49 PM
 * To change this template use File | Settings | File Templates.
 */

/**
 * Mix this in if you want solar system to have fixed map.
 */
trait FixedMap { this: SolarSystem =>
  val map: SsConfig.Data

  override def createObjectsImpl() {
    map.foreach { case(coords, entry) =>
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
    val obj = createObject(
      new Planet(Config.mapSet(entry.mapName).random, entry.ownedByPlayer),
      coords, entry
    )
    obj.createUnits(groundUnits(obj))
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