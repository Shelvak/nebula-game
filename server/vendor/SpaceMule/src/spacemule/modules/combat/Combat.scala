package spacemule.modules.combat

import scala.collection.immutable.HashMap
import scala.collection.mutable
import spacemule.helpers.Converters._
import spacemule.helpers.{StdErrLog => L}
import spacemule.modules.combat.objects._
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.objects.Location

object Combat {
  type NapRules = Map[Int, Set[Int]]

  object Outcome extends Enumeration {
    /**
     * This player has won the battle. Note that if even if you and Nap ended
     * up in a tie because of the pact, both of you will still get Win outcome.
     */
    val Win = Value(0, "win")
    /**
     * This player has lost the battle (all your and your alliance units &
     * buildings were destroyed).
     */
    val Lose = Value(1, "lose")
    /**
     * This player ended up in a tie at this battle (battle ended before you
     * or your allies were wiped out from the battlefield).
     */
    val Tie = Value(2, "tie")
  }

  def apply(location: Location, players: Set[Option[Player]],
            napRules: NapRules, troops: Set[Troop],
            unloadedTroops: Map[Int, Troop],
            buildings: Set[Building]) =
    new Combat(location, players, napRules, troops, unloadedTroops,
               buildings)
}

/**
 * Combat simulator.
 */
class Combat(location: Location, players: Set[Option[Player]],
             napRules: Combat.NapRules, troops: Set[Troop],
             unloadedTroops: Map[Int, Troop],
             buildings: Set[Building]) {
  /**
   * Log of this combat. If there is any units to unload they are unloaded as
   * a first tick.
   */
  val log = {
    val log = new Log()
    val tick = new Log.Tick()

    L.debug("Unloading troops from transporters", () => {
      if (! unloadedTroops.isEmpty && location.kind != Location.Planet)
        throw new IllegalArgumentException(
          "Cannot unload troops if combat is not in planet!")

      unloadedTroops.foreach { case (transporterId, troop) =>
          L.debug(
            "Unloading %s from transporter (id %d)".format(troop, transporterId))
          tick += new Log.Tick.Appear(transporterId, troop)
      }
      
      L.debug("%d troops unloaded".format(unloadedTroops.size))
    })

    if (! tick.isEmpty) log += tick

    log
  }

  /**
   * Map of alliance id => alliance and player id => alliance id.
   */
  val alliances = Alliances(
    players, napRules, troops ++ buildings ++ unloadedTroops.values)

  val statistics = new Statistics(alliances)

  // Launch the combat in the constructor.
  L.debug("Running combat simulation", () => run())

  /**
   * Map of player -> outcome pairs.
   */
  val outcomes = calculateOutcomes()

  /**
   * Calculates outcomes for all the players.
   */
  private def calculateOutcomes() = {
   var outcomes = new HashMap[Option[Player], Combat.Outcome.Value]()

    alliances.eachPlayer { case(player, allianceId) =>
      val outcome =
        if (alliances.isAlive(player))
          if (alliances.hasAliveEnemies(allianceId)) Combat.Outcome.Tie
          else Combat.Outcome.Win
        else Combat.Outcome.Lose
      outcomes = outcomes + (player -> outcome)
    }

    outcomes
  }

  /**
   * Simulate this combat.
   */
  private def run(): Unit = {
    val ticks = Config.combatRoundTicks
    ticks.times { tickIndex =>
      L.debug("Running tick %d/%d".format(tickIndex + 1, ticks), () => {
        // Reset initiative lists if this is not the first tick
        if (tickIndex != 0) alliances.reset

        val tick = simulateTick()

        if (tick.isEmpty) {
          L.debug("Empty tick, ending simulation.")
          return ()
        }
        else log += tick
      })
    }
  }

  /**
   * Simulates one tick.
   */
  private def simulateTick(): Log.Tick = {
    val tick = new Log.Tick()

    L.debug("Traversing initiatives", () =>
      alliances.traverseInitiatives { case (allianceId, combatant) =>
          val fire = L.debug(
            "Combatant %s from alliance id %d is shooting".format(
              combatant, allianceId), 
            () => shootGuns(allianceId, combatant)
          )

          if (! fire.isEmpty) tick += fire
          else L.debug("Combatant could not shoot anything.")
      }
    )

    tick
  }

  private def shootGuns(allianceId: Int, combatant: Combatant) = {
    val fire = new Log.Tick.Fire(combatant)

    combatant.guns.foreach { gun =>
      L.debug("Shooting %s".format(gun), () =>
        alliances.targetFor(allianceId, gun) match {
          case Some(target) => {
              val damage = gun.shoot(target)
              target.hp -= damage
              L.debug("Gun did %d damage to %s".format(damage, target))

              fire.hit(gun, target, damage)

              val (sourceXp, targetXp) = Statistics.xp(target, damage)
              combatant.xp += sourceXp
              target.xp += targetXp
              statistics.damage(combatant, target, damage, sourceXp,
                                targetXp)

              // Mark target as killed if dead
              if (target.isDead) {
                L.debug("Target %s is dead!".format(target))
                alliances.kill(combatant, target)
              }
          }
          case None => L.debug("No target for this gun!")
        }
      )
    }

    fire
  }
}
