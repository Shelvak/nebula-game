package spacemule.modules.pmg.persistence.objects

import spacemule.modules.pmg.persistence.TableIds
import java.util.Date
import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.classes.geom.Coords
import spacemule.modules.pmg.objects.solar_systems.Homeworld
import spacemule.modules.pmg.objects.solar_systems.Wormhole
import spacemule.modules.pmg.objects.{Galaxy, SolarSystem}
import spacemule.persistence.DB

object SolarSystemRow {
  val columns = "`id`, `galaxy_id`, `x`, `y`, `wormhole`, `shield_ends_at`, " +
    "`shield_owner_id`"

  private var _shieldEndsAt: String = null
  def shieldEndsAt = _shieldEndsAt
  def initShieldEndsAt = _shieldEndsAt = DB.date(
    Config.playerShieldDuration.fromNow)
}

case class SolarSystemRow(val galaxyId: Int, val solarSystem: SolarSystem,
coords: Option[Coords]) {
  def this(galaxy: Galaxy, solarSystem: SolarSystem, coords: Coords) =
    this(galaxy.id, solarSystem, Some(coords))

  val playerRow = solarSystem match {
    case homeworld: Homeworld => Some(new PlayerRow(galaxyId, homeworld.player))
    case _ => None
  }

  val id = TableIds.solarSystem.next
  val values = "%d\t%d\t%s\t%s\t%d\t%s\t%s".format(
    id,
    galaxyId,
    coords match {
      case Some(coords) => coords.x.toString
      case None => DB.loadInFileNull
    },
    coords match {
      case Some(coords) => coords.y.toString
      case None => DB.loadInFileNull
    },
    solarSystem match {
      case wh: Wormhole => 1
      case _ => 0
    },
    playerRow match {
      case Some(playerRow) => SolarSystemRow.shieldEndsAt
      case None => DB.loadInFileNull
    },
    playerRow match {
      case Some(playerRow) => playerRow.id.toString
      case None => DB.loadInFileNull
    }
  )
}