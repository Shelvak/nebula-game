/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder

import spacemule.helpers.Converters._
import spacemule.modules.pathfinder.objects._
import spacemule.modules.pmg.classes.geom.Coords
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

    val avoidablePoints = readAvoidablePoints(sourceSs, targetSs,
                                              input.get("avoidable_points"))

    return Map[String, Any](
      "locations" -> Finder.find(
        source, fromJumpgate, sourceSs,
        target, targetJumpgate, targetSs,
        avoidablePoints
      ).map { serverLocation => serverLocation.toMap }
    )
  }

  private def readSolarSystem(input: Option[Any]): Option[SolarSystem] = {
    return input match {
      case None | Some(null) => None
      case Some(thing: Any) => {
        val ssMap = thing.asInstanceOf[Map[String, Int]]
        Some[SolarSystem](
          SolarSystem(
            ssMap.getOrError("id", "id must be defined!"),
            Coords(
              ssMap.getOrError("x", "x must be defined!"),
              ssMap.getOrError("y", "y must be defined!")
            ),
            ssMap.getOrError("galaxy_id", "galaxy_id must be defined!")
          )
        )
      }
    }
  }
  
  private def readSsPoint(solarSystem: SolarSystem,
                          input: Option[Any]): Option[SolarSystemPoint] = {
    return input match {
      case Some(null) | None => None
      case Some(thing: Any) => {
        val sspMap = thing.asInstanceOf[Map[String, Int]]
        Some(
          SolarSystemPoint(
            solarSystem,
            Coords(
              sspMap.getOrError("x", "x must be defined!"),
              sspMap.getOrError("y", "y must be defined!")
            )
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
              Coords(
                input.getOrError("x", "x must be defined for planet!"),
                input.getOrError("y", "y must be defined for planet!")
              )
          )
          case Location.SolarSystemKind => SolarSystemPoint(
              solarSystem match {
                case Some(solarSystem: SolarSystem) => solarSystem
                case None => error(
                  "solar system must be defined if locatable is a ss point!"
                )
              },
              Coords(
                input.getOrError("x", "x must be defined for ss point!"),
                input.getOrError("y", "y must be defined for ss point!")
              )
          )
          case Location.GalaxyKind => GalaxyPoint(
              input.getOrError("id", 
                               "id must be defined for galaxy point!"),
              Coords(
                input.getOrError("x", "x must be defined for galaxy point!"),
                input.getOrError("y", "y must be defined for galaxy point!")
              )
          )
        }
      }
      case None => error("locatable must be defined!")
    }
  }

  private def readAvoidablePoints(ss1: Option[SolarSystem],
                                  ss2: Option[SolarSystem],
                                  input: Option[Any]
  ): Option[Seq[SolarSystemPoint]] = {
    input match {
      case None => None
      case Some(thing) => {
        val locatables = thing.asInstanceOf[Seq[Map[String, Int]]]
        val ss1Id = ss1 match { case None => 0; case Some(ss) => ss.id }
        val ss2Id = ss2 match { case None => 0; case Some(ss) => ss.id }

        val points = locatables.map { json =>
          val id = json.getOrError("id",
            "id must be defined for solar system point!")
          val solarSystem = id match {
            // Bacticks are required to match the value of the val not assign
            // things to ss1Id and ss2Id.
            case `ss1Id` => ss1.get
            case `ss2Id` => ss2.get
            case _ => error(
                "Given avoidable point is not in source nor in target SS!")
          }

          val x = json.getOrError("x",
            "x must be defined for solar system point!")
          val y = json.getOrError("y",
            "y must be defined for solar system point!")

          SolarSystemPoint(solarSystem, Coords(x, y))
        }

        Some(points)
      }
    }
  }
}
