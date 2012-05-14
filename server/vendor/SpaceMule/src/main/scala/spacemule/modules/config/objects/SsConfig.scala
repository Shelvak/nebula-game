package spacemule.modules.config.objects

import spacemule.helpers.JRuby._
import spacemule.modules.pmg.classes.geom.Coords
import org.jruby.runtime.builtin.IRubyObject

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

  private[this] def extractResources(
    data: SRHash[IRubyObject, IRubyObject], key: String = "resources"
  ) = {
    data.by(key).map { array =>
      ResourcesEntry.extract(array.asArray)
    }
  }

  private[this] def extractWreckage(data: SRHash[IRubyObject, IRubyObject]) =
    extractResources(data, "wreckage")

  private[this] def extractUnits(data: SRHash[IRubyObject, IRubyObject]):
  Option[Seq[UnitsEntry]] =
    data.by("units").map { data => UnitsEntry.extract(data.asArray) }

  type Data = Map[Coords, Entry]

  def apply(data: SRHash[IRubyObject, IRubyObject]): Data = {
    data.map { case (positionStr, rbEntryData) =>
      val split = positionStr.toString.split(",").map(_.toInt)
      val (position, angle) = (split(0), split(1))
      val coords = Coords(position, angle)

      val entryData = rbEntryData.asMap
      val entry = entryData("type").toString match {
        case "planet" => SsConfig.PlanetEntry(
          entryData("map").toString,
          entryData("owned_by_player").asBoolean,
          extractWreckage(entryData),
          extractUnits(entryData)
        )
        case "asteroid" => SsConfig.AsteroidEntry(
          extractResources(entryData) match {
            case Some(resources) => resources
            case None => sys.error(
              "Missing asteroid resources for %s!".format(positionStr)
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
    }.toMap
  }
}