package spacemule.modules.config.objects

import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.ss_objects.Planet

object SsConfig {
  sealed abstract class Entry(
    val wreckage: Option[ResourcesEntry],
    val units: Option[Seq[UnitsEntry]]
  )

  case class PlanetEntry(
    mapName: String, terrain: Planet.Terrain.Type,
    override val wreckage: Option[ResourcesEntry] = None,
    override val units: Option[Seq[UnitsEntry]] = None
  ) extends Entry(wreckage, units)

  case class AsteroidEntry(
    resources: ResourcesEntry,
    override val wreckage: Option[ResourcesEntry] = None,
    override val units: Option[Seq[UnitsEntry]] = None
  ) extends Entry(wreckage, units)

  case class JumpgateEntry(
    override val wreckage: Option[ResourcesEntry] = None,
    override val units: Option[Seq[UnitsEntry]] = None
  ) extends Entry(wreckage, units)

  case class NothingEntry(
    override val wreckage: Option[ResourcesEntry] = None,
    override val units: Option[Seq[UnitsEntry]] = None
  ) extends Entry(wreckage, units)

  type CfgMap = Map[String, Any]

  private[this] def extractResources(
    data: CfgMap, key: String = "resources"
  ) = {
    data.get(key).map { array =>
      val resources = array.asInstanceOf[Seq[Double]]
      ResourcesEntry(resources(0), resources(1), resources(2))
    }
  }

  private[this] def extractWreckage(data: CfgMap) =
    extractResources(data, "wreckage")

  private[this] def extractUnits(data: CfgMap):
    Option[Seq[UnitsEntry]] = data.get("units").map(UnitsEntry.extract(_))

  def apply(configKey: String): Map[Coords, Entry] = {
    Config.get[Map[String, CfgMap]](configKey).map {
      case (positionStr, entryData) =>
        val splitted = positionStr.split(",").map(_.toInt)
        val (position, angle) = (splitted(0), splitted(1))
        val coords = Coords(position, angle)

        val entry = entryData("type") match {
          case "planet" => SsConfig.PlanetEntry(
            entryData("map").asInstanceOf[String],
            Planet.Terrain(entryData("terrain").asInstanceOf[Long].toInt),
            extractWreckage(entryData),
            extractUnits(entryData)
          )
          case "asteroid" => SsConfig.AsteroidEntry(
            extractResources(entryData) match {
              case Some(resources) => resources
              case None => sys.error(
                "Missing asteroid resources for %s[%s]['resources']".format(
                  configKey, positionStr
                )
              )
            }, extractWreckage(entryData), extractUnits(entryData)
          )
          case "jumpgate" => SsConfig.JumpgateEntry(
            extractWreckage(entryData), extractUnits(entryData)
          )
          case "nothing" => SsConfig.NothingEntry(
            extractWreckage(entryData), extractUnits(entryData)
          )
        }

        coords -> entry
    }
  }
}