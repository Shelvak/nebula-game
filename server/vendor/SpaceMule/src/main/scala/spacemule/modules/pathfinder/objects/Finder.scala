/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.objects

import scala.collection.mutable.ListBuffer
import spacemule.modules.pathfinder.{galaxy, solar_system}
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects
import spacemule.modules.config.objects.Config
import scala.collection.{Set, Seq}

object Finder {
  def find(
    source: Locatable,
    sourceJumpgates: Set[SolarSystemPoint],
    sourceSs: Option[SolarSystem],
    sourceSsGalaxyCoords: Option[Coords],
    target: Locatable,
    targetJumpgates: Set[SolarSystemPoint],
    targetSs: Option[SolarSystem],
    targetSsGalaxyCoords: Option[Coords],
    avoidablePoints: Option[Seq[SolarSystemPoint]]
  ): Seq[ServerLocation] = {

    // Initialize
    val locations = ListBuffer[ServerLocation]()
    var current = source

    // If we are in planet - first step is to travel to solar system.
    if (current.isInstanceOf[Planet]) {
      val planet = source.asInstanceOf[Planet]
      current = SolarSystemPoint(planet)

      locations += current.toServerLocation(Config.planetLinkWeight)
    }

    // Now we are in solar system or galaxy for sure.
    // Let's try to look if we are in Solar System
    if (current.isInstanceOf[SolarSystemPoint]) {
      val fromPoint = current.asInstanceOf[SolarSystemPoint]

      // Check out if we are in same SS or we have to travel to other one
      if (target.isInstanceOf[InSolarSystem]) {
        val toObject = target.asInstanceOf[InSolarSystem];

        // Yaaay, we have to travel in same SS!
        if (fromPoint.solarSystemId == toObject.solarSystemId) {
          return locations ++ travelToSolarSystemPointOrPlanet(
            fromPoint, target, avoidablePoints)
        }
      }

      // Nop, outer hyperspace awaits us.

      // Travel to the jumpgate
      if (sourceJumpgates.isEmpty)
        sys.error(
          "from jumpgates cannot be Empty if travelling outside SS!"
        )

      locations ++= findInSolarSystem(
        fromPoint, sourceJumpgates,
        // When selecting source solar system jumpgate don't skip it if it is
        // our current location.
        avoidablePoints.map { points => points.filterNot(_ == fromPoint) }
      )

      // Switch traveling source to galaxy.
      current = GalaxyPoint(
        fromPoint.solarSystem.galaxyId,
        sourceSsGalaxyCoords match {
          case Some(coords) => coords
          case None => sys.error(
              "source solar system galaxy jump coordinates must be specified!"
          )
        },
        // Ensure ss->galaxy hop takes as long as galaxy->ss hop.
        1.0 / Config.troopGalaxySsHopTimeRatio *
          fromPoint.solarSystem.wormholeHopMultiplier
      )
      // Add the point in galaxy.
      locations += current.toServerLocation
    }

    // We are in galaxy! Whoa.
    val fromGP = current.asInstanceOf[GalaxyPoint];
    // Let's find out if we're just heading to some other point
    if (target.isInstanceOf[GalaxyPoint]) {
      val toGP = target.asInstanceOf[GalaxyPoint];

      // Travel there
      locations ++= findInGalaxy(fromGP, toGP)
    }
    // Nop, we have to dive to the solar system
    else {
      if (targetJumpgates.isEmpty)
        sys.error(
          "Target jumpgates must be defined if jumping to other SS!"
        )
      val toJumpgate = nearestFor(
        target match {
          case p: Planet => p.solarSystemPoint
          case ssp: SolarSystemPoint => ssp
        },
        targetJumpgates,
        // When selecting target solar system jumpgate don't skip it if it is
        // our target.
        avoidablePoints.map { points => points.filterNot(_ == target) }
      )

      // Travel to the SS we're jumping to
      locations ++= findInGalaxy(
        fromGP,
        GalaxyPoint(
          toJumpgate.solarSystem.galaxyId,
          targetSsGalaxyCoords match {
            case Some(coords) => coords
            case None => sys.error(
                "target solar system galaxy jump coordinates must be specified!"
            )
          }
        )
      )

      // Add jumpgate. Ensure hop takes normal amount of time.
      locations += toJumpgate.toServerLocation(
        toJumpgate.solarSystem.wormholeHopMultiplier)

      // Travel from jumpgate to our destination
      locations ++= travelToSolarSystemPointOrPlanet(toJumpgate, target,
                                                     avoidablePoints)
    }

    locations
  }

  private def travelToSolarSystemPointOrPlanet(
    sourcePoint: SolarSystemPoint, target: Locatable,
    avoidablePoints: Option[Seq[SolarSystemPoint]]
  ): Seq[ServerLocation] = {
    // If location is planet we need to fly there and land.
    if (target.isInstanceOf[Planet]) {
      val toPlanet = target.asInstanceOf[Planet]
      return findInSolarSystem(
        sourcePoint, toPlanet.solarSystemPoint, avoidablePoints
      ) :+ toPlanet.toServerLocation
    }
    else {
      // Check if jumpgate is not our target.
      // If not, we need to travel to our target.
      val toPoint = target.asInstanceOf[SolarSystemPoint]
      if (sourcePoint != toPoint) {
        return findInSolarSystem(sourcePoint, toPoint, avoidablePoints)
      }
      else {
        return Seq[ServerLocation]()
      }
    }
  }

  private def findInSolarSystem(from: SolarSystemPoint,
                                to: Set[SolarSystemPoint],
                                avoidablePoints: Option[Seq[SolarSystemPoint]]
  ): Seq[ServerLocation] = findInSolarSystem(
    from, nearestFor(from, to, avoidablePoints), avoidablePoints)

  private def filterAvoidablePoints(ss: SolarSystem,
                           avoidablePoints: Option[Seq[SolarSystemPoint]]) =
    avoidablePoints match {
      case None => None
      case Some(points) => Some(ss.filterPoints(points))
    }

  private def findInSolarSystem(from: SolarSystemPoint,
                      to: SolarSystemPoint,
                      avoidablePoints: Option[Seq[SolarSystemPoint]]):
  Seq[ServerLocation] = {
    val avoidableInSs = filterAvoidablePoints(from.solarSystem, avoidablePoints)

    solar_system.Finder.find(from.coords, to.coords, avoidableInSs).map {
      hop =>

      ServerLocation(from.solarSystemId, objects.Location.SolarSystem,
                     Some(hop.coords), hop.timeMultiplier)
    }
  }

  private type NFTuple = (SolarSystemPoint, Double)
  private val NearestForOrdering = new Ordering[NFTuple] {
    def compare(a: NFTuple, b: NFTuple) = a._2.compare(b._2)
  }

  private def nearestFor(source: SolarSystemPoint,
                         destinations: Set[SolarSystemPoint],
                         avoidablePoints: Option[Seq[SolarSystemPoint]]):
  SolarSystemPoint = {
    val avoidableInSs = filterAvoidablePoints(source.solarSystem,
                                              avoidablePoints)

    val filteredDestinations = avoidableInSs match {
      case None => destinations
      case Some(points) =>
        destinations.filter { destination =>
          // Only keep this point if it's not in the avoidable list.
          ! points.contains(destination.coords)
        }
    }

    // Use original destinations if filtered destinations are empty.
    val usedDestinations = if (filteredDestinations.isEmpty) destinations
      else filteredDestinations

    // Find nearest destination.
    usedDestinations.map { destination =>
      val hops = findInSolarSystem(source, destination, avoidablePoints)
      val timeMultiplier = hops.foldLeft(0.0) { case (sum, location) =>
          sum + location.timeMultiplier }
      (destination, timeMultiplier)
    }.min(NearestForOrdering)._1
  }

  private def findInGalaxy(from: GalaxyPoint,
                           to: GalaxyPoint): Seq[ServerLocation] = {
    galaxy.Finder.find(from.coords, to.coords).map { hop =>
      ServerLocation(from.id, objects.Location.Galaxy,
                     Some(hop.coords), hop.timeMultiplier)
    }
  }
}
