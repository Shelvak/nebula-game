/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.objects

import scala.collection.mutable.ListBuffer
import spacemule.modules.pathfinder.{galaxy, solar_system}
import spacemule.modules.pmg.objects

object Finder {
  def find(source: Locatable,
           fromJumpgate: Option[SolarSystemPoint],
           sourceSs: Option[SolarSystem],
           target: Locatable,
           targetJumpgate: Option[SolarSystemPoint],
           targetSs: Option[SolarSystem],
           avoidablePoints: Option[Seq[SolarSystemPoint]]):
  Seq[ServerLocation] = {
    // Initialize
    val locations = ListBuffer[ServerLocation]()
    var current = source

    // If we are in planet - first step is to travel to solar system.
    if (current.isInstanceOf[Planet]) {
      val planet = source.asInstanceOf[Planet]
      current = SolarSystemPoint(planet)

      locations += current.toServerLocation
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
      locations ++= findInSolarSystem(fromPoint, fromJumpgate match {
          case Some(ssp) => ssp
          case None => error(
              "from jumpgate cannot be None if travelling outside SS!"
          )
      }, avoidablePoints)

      // Switch traveling source to galaxy.
      current = GalaxyPoint(fromPoint.solarSystem)
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
      val toJumpgate = targetJumpgate match {
          case Some(jumpgate: SolarSystemPoint) => jumpgate
          case None => error(
              "Target jumpgate must be defined if jumping to other SS!"
          )
      }

      // Travel to the SS we're jumping to
      locations ++= findInGalaxy(fromGP, toJumpgate.solarSystem.galaxyPoint)

      // Add jumpgate.
      locations += toJumpgate.toServerLocation

      // Travel from jumpgate to our destination
      locations ++= travelToSolarSystemPointOrPlanet(toJumpgate, target,
                                                     avoidablePoints)
    }

    return locations
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
                      to: SolarSystemPoint,
                      avoidablePoints: Option[Seq[SolarSystemPoint]]):
  Seq[ServerLocation] = {
    val points = avoidablePoints match {
      case None => None
      case Some(points) => Some(from.solarSystem.filterPoints(points))
    }

    solar_system.Finder.find(from.coords, to.coords, points).map {
      hop =>

      ServerLocation(from.solarSystemId, objects.Location.SolarSystemKind,
                     Some(hop.coords.x), Some(hop.coords.y), hop.timeMultiplier)
    }
  }

  private def findInGalaxy(from: GalaxyPoint,
                           to: GalaxyPoint): Seq[ServerLocation] = {
    galaxy.Finder.find(from.coords, to.coords).map { hop =>
      ServerLocation(from.id, objects.Location.GalaxyKind,
                     Some(hop.coords.x), Some(hop.coords.y), hop.timeMultiplier)
    }
  }
}
