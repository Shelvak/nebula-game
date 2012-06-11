package spacemule.modules.config.objects

import spacemule.helpers.JRuby._
import spacemule.modules.pmg.classes.geom.Coords
import scala.{collection => sc}

object SsConfig {
  sealed abstract class Entry(
    val wreckage: Option[ResourcesEntry],
    val units: Option[Seq[UnitsEntry]]
  ) {
    override def toString = "<SsConfig.Entry wreckage:" + (wreckage match {
      case None => "none"
      case Some(resourcesEntry) => resourcesEntry
    }) + " units:" + (units match {
      case None => "none"
      case Some(seq) => seq.size
    }) + ">"
  }

  case class PlanetEntry(
    mapName: String, ownedByPlayer: Boolean,
    override val wreckage: Option[ResourcesEntry] = None,
    override val units: Option[Seq[UnitsEntry]] = None
  ) extends Entry(wreckage, units)

  case class AsteroidEntry(
    resources: ResourcesEntry,
    override val wreckage: Option[ResourcesEntry] = None,
    override val units: Option[Seq[UnitsEntry]] = None
  ) extends Entry(wreckage, units) {
    override def toString = "<AsteroidEntry resources:"+resources+" "+
      super.toString+">"
  }

  case class JumpgateEntry(
    override val wreckage: Option[ResourcesEntry] = None,
    override val units: Option[Seq[UnitsEntry]] = None
  ) extends Entry(wreckage, units)

  case class NothingEntry(
    override val wreckage: Option[ResourcesEntry] = None,
    override val units: Option[Seq[UnitsEntry]] = None
  ) extends Entry(wreckage, units)

  // ResourcesEntry data map
  type REDataMap = sc.Map[String, ResourcesEntry.Data]
  // UnitsEntry data map
  type UEDataMap = sc.Map[String, UnitsEntry.Data]
  // Generic data structure.
  type Data = Map[Coords, Entry]

  private[this] def extractResources(
    data: REDataMap, key: String = "resources"
  ) = {
    data.get(key).map { array =>
      ResourcesEntry.extract(array)
    }
  }

  private[this] def extractWreckage(data: REDataMap) =
    extractResources(data, "wreckage")

  private[this] def extractUnits(data: UEDataMap): Option[Seq[UnitsEntry]] =
    data.get("units").map { UnitsEntry.extract(_) }

  def apply(data: sc.Map[String, Any]): Data = {
    data.map { case (positionStr, rbEntryData) =>
      val split = positionStr.toString.split(",").map(_.toInt)
      val (position, angle) = (split(0), split(1))
      val coords = Coords(position, angle)

      val entryData = rbEntryData.asInstanceOf[sc.Map[String, Any]]
      val entry = entryData("type").toString match {
        case "planet" => SsConfig.PlanetEntry(
          entryData("map").toString,
          entryData("owned_by_player").asInstanceOf[Boolean],
          extractWreckage(entryData.asInstanceOf[REDataMap]),
          extractUnits(entryData.asInstanceOf[UEDataMap])
        )
        case "asteroid" => SsConfig.AsteroidEntry(
          extractResources(entryData.asInstanceOf[REDataMap]) match {
            case Some(resources) => resources
            case None => sys.error(
              "Missing asteroid resources for %s!".format(positionStr)
            )
          },
          extractWreckage(entryData.asInstanceOf[REDataMap]),
          extractUnits(entryData.asInstanceOf[UEDataMap])
        )
        case "jumpgate" => SsConfig.JumpgateEntry(
          extractWreckage(entryData.asInstanceOf[REDataMap]),
          extractUnits(entryData.asInstanceOf[UEDataMap])
        )
        case "nothing" => SsConfig.NothingEntry(
          extractWreckage(entryData.asInstanceOf[REDataMap]),
          extractUnits(entryData.asInstanceOf[UEDataMap])
        )
      }

      coords -> entry
    }.toMap
  }
}