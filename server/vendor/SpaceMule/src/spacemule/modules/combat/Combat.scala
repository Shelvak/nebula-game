package spacemule.modules.combat

import scala.collection.mutable
import spacemule.helpers.Converters._
import spacemule.modules.combat.objects._
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.objects.Location

object Combat {
  class Statistics()
}

/**
 * General combat simulator.
 */
class Combat(location: Location, players: Set[Option[Player]],
             napRules: NapRules, units: Set[Troop],
             buildings: Set[Building]) {

  /**
   * Map of alliance id => alliance and player id => alliance id.
   */
  val alliances = Alliances(players, napRules, units ++ buildings)

  def run() = {
    val log = (0 to Config.combatRoundTicks).map { tick => simulateTick() }
  }

  /**
   * Simulates one tick.
   */
  private def simulateTick() = {
    var shot = false

    alliances.traverseInitiatives { case (allianceId, combatant) =>
        combatant.guns.foreach { gun =>
          alliances.targetFor(allianceId, gun) match {
            case Some(target) => {
                shot = true
                val damage = gun.shoot(target)
                target.hp -= damage

                // Mark target as killed if dead
                if (target.isDead) alliances.kill(target)
            }
            case None => ()
          }
        }
    }

    shot
  }
}
