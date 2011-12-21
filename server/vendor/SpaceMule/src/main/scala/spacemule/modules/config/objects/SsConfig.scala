package spacemule.modules.config.objects

import spacemule.modules.pmg.classes.geom.Coords

object SsConfig {
  sealed abstract class Entry(
    val wreckage: Option[ResourcesEntry],
    val units: Option[Seq[UnitsEntry]]
  )

  case class PlanetEntry(
    mapName: String, ownedByPlayer: Boolean,
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
      ResourcesEntry.extract(array)
    }
  }

  private[this] def extractWreckage(data: CfgMap) =
    extractResources(data, "wreckage")

  private[this] def extractUnits(data: CfgMap):
    Option[Seq[UnitsEntry]] = data.get("units").map(UnitsEntry.extract(_))

  type Data = Map[Coords, Entry]

  def apply(configKey: String): Data = {
    val data = Config.get[Map[String, CfgMap]](configKey)
    apply(configKey, data)
  }

  def apply(configKey: String, data: Map[String, CfgMap]) = {
    data.map { case (positionStr, entryData) =>
      val splited = positionStr.split(",").map(_.toInt)
      val (position, angle) = (splited(0), splited(1))
      val coords = Coords(position, angle)

      val entry = entryData("type") match {
        case "planet" => SsConfig.PlanetEntry(
          entryData("map").asInstanceOf[String],
          entryData("owned_by_player").asInstanceOf[Boolean],
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