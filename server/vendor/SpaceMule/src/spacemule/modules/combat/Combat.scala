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
             napRules: NapRules, troops: Set[Troop],
             unloadedTroops: Map[Int, Troop],
             buildings: Set[Building]) {
  /**
   * Log of this combat. If there is any units to unload they are unloaded as
   * a first tick.
   */
  val log = {
    val log = new Log()
    val tick = new Log.Tick()

    if (! unloadedTroops.isEmpty && location.kind != Location.PlanetKind)
      throw new IllegalArgumentException(
        "Cannot unload troops if combat is not in planet!")

    unloadedTroops.foreach { case (transporterId, troop) =>
        L.debug(
          "Unloading %s from transporter (id %d)".format(troop, transporterId))
        tick += new Log.Tick.Appear(transporterId, troop)
    }
    L.debug("%d troops unloaded".format(unloadedTroops.size))

    if (! tick.isEmpty) log += tick

    log
  }

  /**
   * Map of alliance id => alliance and player id => alliance id.
   */
  val alliances = Alliances(
    players, napRules, troops ++ buildings ++ unloadedTroops.values)

  // Launch the combat in the constructor.
  run()

  /**
   * Simulate this combat.
   */
  private def run(): Unit = {
    L.withLevel(L.Debug) { () =>
      val statistics = new Statistics(alliances)

      val ticks = Config.combatRoundTicks
      ticks.times { tickIndex =>
        L.debug("Running tick %d/%d".format(tickIndex, ticks), () => {
          // Reset initiative lists if this is not the first tick
          if (tickIndex == 0) {
            
          }
          else alliances.reset

          val tick = simulateTick(statistics)

          if (tick.isEmpty) return ()
          else log += tick
        })
      }
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
