package spacemule.modules.pmg.objects

import spacemule.modules.pmg.classes.geom.Coords
import ss_objects.{Jumpgate, Asteroid, Planet}
import spacemule.modules.config.objects.{SsConfig, ResourcesEntry, Config}
import spacemule.logging.Log
import spacemule.helpers.JRuby._

class SolarSystem(map: Option[SsConfig.Data]) {
  def this(map: SsConfig.Data) = this(Some(map))

  val kind = SolarSystem.Normal

  val orbitCount = Config.orbitCount

  private[this] var _objects = Map.empty[Coords, SSObject]
  def objects = _objects

  /**
   * Units in solar system.
   */
  private[this] var _units = Map.empty[Coords, Seq[Troop]]
  def units = _units

  /**
   * Wreckage in orbit.
   */
  private[this] var _wreckages = Map.empty[Coords, ResourcesEntry]
  def wreckages = _wreckages

  private[this] var objectsCreated = false

  override def toString = "<SolarSystem>"

  def createObjects() {
    if (objectsCreated) {
      sys.error("Can only create objects once per SolarSystem!")
    }

    createObjectsImpl()

    objectsCreated = true
  }

  protected[this] def createObjectsImpl() {
    map match {
      case None => ()
      case Some(m) =>
        m.foreach { case(coords, entry) =>
          entry match {
            case e: SsConfig.PlanetEntry => createPlanet(coords, e)
            case e: SsConfig.AsteroidEntry => createAsteroid(coords, e)
            case e: SsConfig.JumpgateEntry =>
              createObject(new Jumpgate, coords, e)
            case e: SsConfig.NothingEntry => createObjectAssets(coords, e)
          }
        }
    }
  }

  private[this] def createPlanet(
    coords: Coords, entry: SsConfig.PlanetEntry
  ) {
    Log.block(
      "Creating planet @ "+coords+" from map "+entry.mapName,
      level=Log.Debug
    ) { () =>
      createObject(
        new Planet(Config.planetMap(entry.mapName), entry.ownedByPlayer),
        coords, entry
      )
    }
  }

  private[this] def createAsteroid(
    coords: Coords, entry: SsConfig.AsteroidEntry
  ) {
    Log.block(
      "Creating asteroid @ "+coords+" from "+entry,
      level=Log.Debug
    ) { () =>
      createObject(
        new Asteroid(
          entry.resources.metal, entry.resources.energy, entry.resources.zetium
        ),
        coords, entry
      )
    }
  }

  private[this] def createObject(
    obj: SSObject, coords: Coords, entry: SsConfig.Entry
  ) = {
    _objects += coords -> obj
    createObjectAssets(coords, entry)
    obj
  }

  private[this] def createObjectAssets(coords: Coords, entry: SsConfig.Entry) {
    entry.units match {
      case None => ()
      case Some(units) =>
        Log.block(
          "Creating "+entry.units.size+" units @ "+coords,
          level=Log.Debug
        ) { () =>
          val addedUnits = units.flatMap(_.createTroops())

          if (_units.contains(coords)) {
            _units += coords -> (_units(coords) ++ addedUnits)
          }
          else
            _units += coords -> addedUnits
        }
    }

    entry.wreckage match {
      case None => ()
      case Some(wreckage) => _wreckages += coords -> wreckage
    }
  }
}

object SolarSystem extends Enumeration {
  private[this] def const(name: String) =
    RClass("SolarSystem").getConstant("KIND_" + name.toUpperCase).asInt

  val Normal = Value(const("normal"), "normal")
  val Wormhole = Value(const("wormhole"), "wormhole")
  val Battleground = Value(const("battleground"), "battleground")
  val Pooled = Value(const("pooled"), "pooled")
  type Kind = Value
}