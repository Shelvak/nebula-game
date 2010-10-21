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
//    Locatable source = readLocatable(sourceSs, input.get("from"));
//
    val targetSs = readSolarSystem(input.get("to_solar_system"))
    val targetJumpgate = targetSs match {
      case Some(solarSystem: SolarSystem) => {
        readSsPoint(solarSystem, input.get("to_jumpgate"))
      }
      case None => None
    }
//    Locatable target = readLocatable(targetSs, input.get("to"));


    return Map[String, Any]()
  }

  private def readSolarSystem(input: Option[Any]):
      Option[SolarSystem] = {
    return input match {
      case Some(ssMap: Map[String, Int]) => {
        Some[SolarSystem](
          SolarSystem(
            ssMap.getOrError("id", "id must be defined!"),
            ssMap.getOrError("x", "x must be defined!"),
            ssMap.getOrError("y", "y must be defined!"),
            ssMap.getOrError("galaxy_id", "galaxy_id must be defined!")
          )
        )
      }
      case None => None
    }
  }
  
  private def readSsPoint(solarSystem: SolarSystem, input: Option[Any]):
      SolarSystemPoint = {
    return input match {
      case Some(sspMap: Map[String, Int]) => {
        SolarSystemPoint(
          solarSystem,
          sspMap.getOrError("x", "x must be defined!"),
          sspMap.getOrError("y", "y must be defined!")
        )
      }
      case None => error(
          "If solar_system is defined so must be it's jumpgate!"
      )
    }
  }

  private def readLocatable(solarSystem: Option[SolarSystem],
                            input: Map[String, Int]): Locatable = {
    val kind = input.getOrError("type", "type must be defined for locatable!")

    return kind match {
      case Location.PlanetKind => Planet(
          input.getOrError("id", "id must be defined for planet!"),
          solarSystem,
          input.getOrError("x", "x must be defined for planet!"),
          input.getOrError("y", "y must be defined for planet!")
      )
      case Location.SolarSystemKind => SolarSystemPoint(
          solarSystem,
          input.getOrError("x", "x must be defined for solar system point!"),
          input.getOrError("y", "y must be defined for solar system point!")
      )
      case Location.GalaxyKind => GalaxyPoint(
          input.getOrError("id", "id must be defined for galaxy point!"),
          input.getOrError("x", "x must be defined for galaxy point!"),
          input.getOrError("y", "y must be defined for galaxy point!")
      )
    }
  }
}
