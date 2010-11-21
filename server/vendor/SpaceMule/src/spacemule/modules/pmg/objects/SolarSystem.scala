package spacemule.modules.pmg.objects

import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.classes.geom.Coords
import ss_objects.{Jumpgate, RichAsteroid, Asteroid, Planet}
import util.Random
import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.HashMap
import spacemule.helpers.Converters._

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 12:11:38 PM
 * To change this template use File | Settings | File Templates.
 */

trait SolarSystem {
  val orbitCount = Config.orbitCount
  val planetCount = Config.planetCount(this)
  val jumpgateCount = Config.jumpgateCount(this)
  val objects = HashMap[Coords, SSObject]()

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
      error("Can only create objects once per SolarSystem!")
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
    def rand: Coords = {
      // There cannot be more than one planet in orbit! Also jumpgates are always
      // in outer ring.
      val position = obj match {
        case obj: Planet => {
          val position = availableOrbits.random
          availableOrbits -= position
          position
        }
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
      while (! found) {
        coordinate = rand
        found = check(coordinate)
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
      obj.initialize
      objects(randCoordinateFor(obj)) = obj
      createOrbitUnits(obj)
    }
  }

  private def createOrbitUnits(obj: SSObject) = {
    val orbitChances = orbitUnitChances
    if (obj.hasOrbitUnits(orbitChances)) {
      val unitChances = orbitUnits
      obj.createOrbitUnits(unitChances)
    }
  }

  /**
   * Chance if any units will appear in SS orbit.
   */
  protected def orbitUnitChances = Config.ssObjectOrbitUnitChances

  /**
   * Chances what units will appear in SS orbit.
   */
  protected def orbitUnits = Config.npcOrbitUnitChances
}

object SolarSystem {
  /**
   *  Returns "random" angle. Each position have certain allowed angles and
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