package spacemule.modules.combat

import scala.collection.mutable
import spacemule.modules.combat.objects.combat
import spacemule.modules.combat.objects.Alliance
import spacemule.modules.combat.objects.Building
import spacemule.modules.combat.objects.NapRules
import spacemule.modules.combat.objects.Player
import spacemule.modules.combat.objects.Unit
import spacemule.modules.combat.objects.combat.AlliancesList
import spacemule.modules.pmg.objects.Location

/**
 * General combat simulator.
 */
class Combat(location: Location, players: Set[Option[Player]],
             napRules: NapRules, units: Set[Unit],
             buildings: Set[Building]) {
  /**
   * Players grouped by alliance id.
   */
  val alliances = Alliance.group(players)

  val alliancesList = new AlliancesList(napRules)
  /**
   * Map of units stored in transporters.
   * {
   *   transporter.id => [
   *     [unit, unit, unit], # Flank 1
   *     [unit, unit, unit], # Flank 2
   *   ]
   * }
   */
  val storedUnits = new mutable.HashMap[Int, mutable.Seq[Unit]]()

  /**
   * Map of transporterId => loadedVolume pairs.
   */
  val transporterBuckets = new mutable.HashMap[Int, Int]()

  // Register players to alliances
  alliances.foreach { case(allianceId, alliance) =>
      alliancesList(allianceId) = new combat.Alliance(alliancesList, allianceId)

      alliance.foreach { player =>
        alliancesList.registerPlayer(allianceId, player)
      }
  }

  // Add units.
  units.foreach { unit =>
    val alliance = alliancesList.allianceFor(unit.player)
    alliance += unit

    // Check if this is a transported and has something stored there.
    unit.units match {
      case Some(units) => {
          storedUnits(unit.id) = units.toBuffer.sorted
      }
      case None => {}
    }
  }

  val damageDealtPlayer = new mutable.HashMap[Player, Int]()
  val damageTakenPlayer = new mutable.HashMap[Player, Int]()
  val damageDealtAlliance = new mutable.HashMap[Int, Int]()
  val damageTakenAlliance = new mutable.HashMap[Int, Int]()

  def run() = {
    runCombat()
  }

  private def runCombat() = {

  }
}
