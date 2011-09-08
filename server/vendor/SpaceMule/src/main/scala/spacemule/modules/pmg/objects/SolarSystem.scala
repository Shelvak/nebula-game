package spacemule.modules.pmg.objects

import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.classes.geom.Coords
import ss_objects.{Jumpgate, RichAsteroid, Asteroid, Planet}
import util.Random
import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.HashMap
import spacemule.helpers.Converters._

class SolarSystem {
  val orbitCount = Config.orbitCount
  val planetCount = Config.planetCount(this)
  val jumpgateCount = Config.jumpgateCount(this)
  val objects = HashMap[Coords, SSObject]()
  val wormhole = false
  val shielded = false

  if (planetCount > orbitCount) {
    throw new Exception("Planet count %d is more than orbit count %d!".format(
      planetCount, orbitCount))
  }

  /**
   * Ensures that multiple planets can't be on same orbit.
   */
  val availableOrbits = new ArrayBuffer[Int](orbitCount)

  // Cache available orbits
  (0 until orbitCount).foreach { position =>
    availableOrbits += position
  }

  private var objectsCreated = false

  def createObjects() = {
    if (objectsCreated) {
      sys.error("Can only create objects once per SolarSystem!")
    }

    createPlanets()
    
    createObjectType(Config.asteroidCount(this)) { () => new Asteroid() }
    createObjectType(Config.richAsteroidCount(this)) { () => new RichAsteroid() }
    createJumpgates()

    objectsCreated = true
  }

  /**
   * For overriding in Homeworld solar systems.
   */
  protected def createPlanets() = {
    createObjectType(planetCount) { () => new Planet() }
  }

  /**
   * For overriding in Homeworld solar systems.
   */
  protected def createJumpgates() = {
    createObjectType(jumpgateCount) { () => new Jumpgate() }
  }

  /**
   * Returns a random coordinate. Checks that objects wouldn't appear below
   * others. Ensures that there is only one planet per orbit.
   *
   * Warning, this method WILL LOOP indefinitely if there are no spaces left!
   */
  private def randCoordinateFor(obj: SSObject): Coords = {
    val maxIterations = 1000

    def rand: Coords = {
      // There cannot be more than one planet in orbit! Also jumpgates are always
      // in outer ring.
      val position = obj match {
        case obj: Planet => availableOrbits.random
        case obj: Jumpgate => orbitCount
        case obj: SSObject => Random.nextInt(orbitCount)
      }

      val angle = SolarSystem.randAngle(position)
      return new Coords(position, angle)
    }

    def check(coordinate: Coords): Boolean = {
      if (! objects.contains(coordinate)) {
        // If this coordinate is perpendicular top one, also check if we have
        // nothing directly below us.
        val (position, angle) = (coordinate.position, coordinate.angle)
        val perpendicular = angle == 90 || angle == 270
        if (
          (
            perpendicular &&
            ! objects.contains(new Coords(position - 1, angle)) &&
            ! objects.contains(new Coords(position + 1, angle))
          )
          || ! perpendicular
        ) {
          return true
        }
      }

      return false
    }

    try {
      var coordinate: Coords = rand
      var found = check(coordinate)
      var iteration = 0
      while (! found) {
        if (iteration < maxIterations) {
          coordinate = rand
          found = check(coordinate)
        }
        else {
          throw new IllegalStateException(
            (
              "Stuck in a loop trying to find position for %s in %s! " +
              "Max iteration count (%d) reached!"
            ).format(obj.toString, this.toString, maxIterations)
          )
        }

        iteration += 1
      }

      // Remove position from
      obj match {
        case obj: Planet => availableOrbits -= coordinate.position
        case _ => ()
      }

      return coordinate
    }
    catch {
      case e: IllegalStateException => throw new IllegalStateException(
        "No free spot available for %s in %s!".format(
          obj.toString, this.toString
        )
      )
    }
  }

  protected def createObjectType(count: Int)(create: () => SSObject) = {
    (1 to count).foreach { index =>
      val obj = create()
      initializeAndAdd(obj, randCoordinateFor(obj))
    }
  }

  protected def initializeAndAdd(obj: SSObject, coords: Coords) = {
    obj.createUnits(groundUnits(obj))
    obj.createOrbitUnits(orbitUnits(obj))
    obj.initialize
    objects(coords) = obj
  }
  
  /**
   * What units will appear in SS object?
   */
  protected def groundUnits(obj: SSObject) = obj match {
    case planet: Planet => Config.regularPlanetGroundUnits
    case _ => Nil
  }

  /**
   * What units will appear on solar system orbit?
   */
  protected def orbitUnits(obj: SSObject) = obj match {
    case planet: Planet => Config.regularPlanetOrbitUnits
    case asteroid: RichAsteroid => Config.regularRichAsteroidOrbitUnits
    case asteroid: Asteroid => Config.regularAsteroidOrbitUnits
    case jumpgate: Jumpgate => Config.regularJumpgateOrbitUnits
  }
}

object SolarSystem extends Enumeration {
  val Normal = Value(0, "normal")
  val Wormhole = Value(1, "wormhole")
  val Battleground = Value(2, "battleground")
  type Kind = Value
      
  /**
   * Returns "random" angle. Each position have certain allowed angles and
   * this method returns one of them.
   */
  def randAngle(position: Int): Int = {
    val numOfQuarterPoints = position + 1
    val quarterPointDegrees = 90 / numOfQuarterPoints

    // random quarter + random point
    return Random.nextInt(4) * 90 +
            Random.nextInt(numOfQuarterPoints) * quarterPointDegrees
  }
}