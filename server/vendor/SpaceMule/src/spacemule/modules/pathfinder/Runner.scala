/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder

import spacemule.helpers.Converters._
import spacemule.modules.pathfinder.objects._
import spacemule.modules.pmg.objects.Location

object Runner {
  def run(input: Map[String, Any]): Map[String, Any] = {
    val sourceSs = readSolarSystem(input.get("from_solar_system"))
    val fromJumpgate = sourceSs match {
      case Some(solarSystem: SolarSystem) => {
        readSsPoint(solarSystem, input.get("from_jumpgate"))
      }
      case None => None
    }
    val source = readLocatable(sourceSs, input.get("from"))

    val targetSs = readSolarSystem(input.get("to_solar_system"))
    val targetJumpgate = targetSs match {
      case Some(solarSystem: SolarSystem) => {
        readSsPoint(solarSystem, input.get("to_jumpgate"))
      }
      case None => None
    }
    val target = readLocatable(targetSs, input.get("to"))

    return Map[String, Any](
      "locations" -> Finder.find(
        source, fromJumpgate, sourceSs,
        target, targetJumpgate, targetSs
      ).map { serverLocation => serverLocation.toMap }
    )
  }

  private def readSolarSystem(input: Option[Any]):
      Option[SolarSystem] = {
    return input match {
      case None | Some(null) => None
      case Some(thing: Any) => {
        val ssMap = thing.asInstanceOf[Map[String, Int]]
        Some[SolarSystem](
          SolarSystem(
            ssMap.getOrError("id", "id must be defined!"),
            ssMap.getOrError("x", "x must be defined!"),
            ssMap.getOrError("y", "y must be defined!"),
            ssMap.getOrError("galaxy_id", "galaxy_id must be defined!")
          )
        )
      }
    }
  }
  
  private def readSsPoint(solarSystem: SolarSystem, input: Option[Any]):
      Option[SolarSystemPoint] = {
    return input match {
      case Some(null) | None => None
      case Some(thing: Any) => {
        val sspMap = thing.asInstanceOf[Map[String, Int]]
        Some(
          SolarSystemPoint(
            solarSystem,
            sspMap.getOrError("x", "x must be defined!"),
            sspMap.getOrError("y", "y must be defined!")
          )
        )
      }
    }
  }

  private def readLocatable(solarSystem: Option[SolarSystem],
                            input: Option[Any]): Locatable = {
    input match {
      case Some(thing: Any) => {
        val input = thing.asInstanceOf[Map[String, Int]]
        val kind = input.getOrError("type",
                                    "type must be defined for locatable!"
        )

        return kind match {
          case Location.PlanetKind => Planet(
              input.getOrError("id", "id must be defined for planet!"),
              solarSystem match {
                case Some(solarSystem: SolarSystem) => solarSystem
                case None => error(
                    "solar system must be defined if locatable is a planet!"
                )
              },
              input.getOrError("x", "x must be defined for planet!"),
              input.getOrError("y", "y must be defined for planet!")
          )
          case Location.SolarSystemKind => SolarSystemPoint(
              solarSystem match {
                case Some(solarSystem: SolarSystem) => solarSystem
                case None => error(
                  "solar system must be defined if locatable is a ss point!"
                )
              },
              input.getOrError("x",
                               "x must be defined for solar system point!"
              ),
              input.getOrError("y",
                               "y must be defined for solar system point!"
              )
          )
          case Location.GalaxyKind => GalaxyPoint(
              input.getOrError("id", 
                               "id must be defined for galaxy point!"),
              input.getOrError("x", 
                               "x must be defined for galaxy point!"),
              input.getOrError("y", 
                               "y must be defined for galaxy point!")
          )
        }
      }
      case None => error("locatable must be defined!")
    }
  }
}
