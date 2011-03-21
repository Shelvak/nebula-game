package spacemule.modules.combat

import scala.collection.mutable
import spacemule.helpers.Converters._
import spacemule.helpers.{StdErrLog => L}
import spacemule.modules.combat.objects._
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.objects.Location

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

  def run(): Log = {
    L.withLevel(L.Debug) { () =>
      val log = new Log()
      val statistics = new Statistics(alliances)

      val ticks = Config.combatRoundTicks
      ticks.times { tickIndex =>
        L.debug("Running tick %d/%d".format(tickIndex, ticks), () => {
          // Reset initiative lists if this is not the first tick
          if (tickIndex != 0) alliances.reset

          val tick = simulateTick(statistics)

          if (tick.isEmpty) return log
          else log += tick
        })
      }

      log
    }
  }

  /**
   * Simulates one tick.
   */
  private def simulateTick(statistics: Statistics): Log.Tick = {
    val tick = new Log.Tick()

    alliances.traverseInitiatives { case (allianceId, combatant) =>
        val fire = new Log.Tick.Fire(combatant)

        combatant.guns.foreach { gun =>
          alliances.targetFor(allianceId, gun) match {
            case Some(target) => {
                val damage = gun.shoot(target)
                target.hp -= damage

                fire.hit(gun, target, damage)

                val (sourceXp, targetXp) = Statistics.xp(target, damage)
                combatant.xp += sourceXp
                target.xp += targetXp
                statistics.damage(combatant, target, damage, sourceXp, targetXp)

                // Mark target as killed if dead
                if (target.isDead) alliances.kill(target)
            }
            case None => ()
          }
        }

        if (! fire.isEmpty) tick += fire
    }

    tick
  }
}
