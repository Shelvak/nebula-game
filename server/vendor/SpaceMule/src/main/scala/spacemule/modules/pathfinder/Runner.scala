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
    val fromJumpgates = sourceSs match {
      case Some(solarSystem: SolarSystem) => {
        readSsPoints(solarSystem, input.get("from_jumpgates"))
      }
      case None => Set.empty[SolarSystemPoint]
    }
    val sourceSsGalaxyCoords = sourceSs match {
      case Some(solarSystem: SolarSystem) => readCoords(
          input.get("from_ss_galaxy_coords"))
      case None => None
    }
    val source = readLocatable(sourceSs, input.get("from"))

    val targetSs = readSolarSystem(input.get("to_solar_system"))
    val targetJumpgates = targetSs match {
      case Some(solarSystem: SolarSystem) => {
        readSsPoints(solarSystem, input.get("to_jumpgates"))
      }
      case None => Set.empty[SolarSystemPoint]
    }
    val targetSsGalaxyCoords = targetSs match {
      case Some(solarSystem: SolarSystem) => readCoords(
          input.get("to_ss_galaxy_coords"))
      case None => None
    }
    val target = readLocatable(targetSs, input.get("to"))

    val avoidablePoints = readAvoidablePoints(sourceSs, targetSs,
                                              input.get("avoidable_points"))

    return Map[String, Any](
      "locations" -> Finder.find(
        source, fromJumpgates, sourceSs, sourceSsGalaxyCoords,
        target, targetJumpgates, targetSs, targetSsGalaxyCoords,
        avoidablePoints
      ).map { serverLocation => serverLocation.toMap }
    )
  }

  private def readSolarSystem(input: Option[Any]): Option[SolarSystem] = {
    return input match {
      case None | Some(null) => None
      case Some(thing: Any) => {
        val ssMap = thing.asInstanceOf[Map[String, Int]]
        // Needed, because accessing ssMap yields this warning:
        // warning: comparing values of types Int and Null using `==' will
        // always yield false
        val ssMapAny = thing.asInstanceOf[Map[String, Any]]
        val x = ssMapAny.get("x") match {
          case Some(null) => None
          case Some(x: Int) => Some(x)
          case None => sys.error("x must be defined!")
        }
        val y = ssMapAny.get("y") match {
          case Some(null) => None
          case Some(y: Int) => Some(y)
          case None => sys.error("y must be defined!")
        }

        val coordsError = (x: Option[Int], y: Option[Int]) => sys.error(
          "Only one of the x & y was defined! x: %s, y: %s".format(
            x.toString, y.toString
          )
        )
        // Check if both or neither of x & y are defined.
        val coords = x match {
          case Some(mx) => y match {
              case Some(my) => Some(Coords(mx, my))
              case None => coordsError(x, y)
          }
          case None => y match {
              case Some(mx) => coordsError(x, y)
              case None => None
          }
        }

        Some(
          SolarSystem(
            ssMap.getOrError("id", "id must be defined!"),
            coords,
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

  private def readSsPoints(solarSystem: SolarSystem,
                           input: Option[Any]): Set[SolarSystemPoint] = {
    return input match {
      case Some(null) | None => Set.empty
      case Some(thing: Any) => {
          val sspList = thing.asInstanceOf[Seq[Any]]
          sspList.map { item => readSsPoint(solarSystem, Some(item)) }.flatten.
            toSet
      }
    }
  }

  private def readLocatable(solarSystem: Option[SolarSystem],
                            input: Option[Any]): Locatable = {
    input match {
      case Some(thing: Any) => {
        val input = thing.asInstanceOf[Map[String, Int]]
        val kind = Location(
          input.getOrError("type", "type must be defined for locatable!").
          asInstanceOf[Int]
        )

        return kind match {
          case Location.Planet => Planet(
              input.getOrError("id", "id must be defined for planet!"),
              solarSystem match {
                case Some(solarSystem: SolarSystem) => solarSystem
                case None => sys.error(
                    "solar system must be defined if locatable is a planet!"
                )
              },
              Coords(
                input.getOrError("x", "x must be defined for planet!"),
                input.getOrError("y", "y must be defined for planet!")
              )
          )
          case Location.SolarSystem => SolarSystemPoint(
              solarSystem match {
                case Some(solarSystem: SolarSystem) => solarSystem
                case None => sys.error(
                  "solar system must be defined if locatable is a ss point!"
                )
              },
              Coords(
                input.getOrError("x", "x must be defined for ss point!"),
                input.getOrError("y", "y must be defined for ss point!")
              )
          )
          case Location.Galaxy => GalaxyPoint(
              input.getOrError("id", 
                               "id must be defined for galaxy point!"),
              Coords(
                input.getOrError("x", "x must be defined for galaxy point!"),
                input.getOrError("y", "y must be defined for galaxy point!")
              )
          )
        }
      }
      case None => sys.error("locatable must be defined!")
    }
  }

  private def readCoords(input: Option[Any]): Option[Coords] = {
    input match {
      case None => None
      case Some(thing) => {
          val coords = thing.asInstanceOf[Seq[Int]]
          if (coords == null) None else Some(Coords(coords(0), coords(1)))
      }
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
            case _ => sys.error(
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
