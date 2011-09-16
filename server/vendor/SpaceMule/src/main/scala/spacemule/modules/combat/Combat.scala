package spacemule.modules.combat

import scala.{collection => sc}
import scala.collection.mutable
import spacemule.helpers.Converters._
import spacemule.helpers.{StdErrLog => L}
import spacemule.modules.combat.objects._
import spacemule.modules.combat.post_combat._
import spacemule.modules.config.objects.Config
import spacemule.modules.pmg.objects.Location

object Combat {
  // alliance id -> alliance name
  type AllianceNames = sc.Map[Long, String]
  // alliance id -> Set[napped alliance ids]
  type NapRules = sc.Map[Long, Set[Long]]
  type LoadedTroops = sc.Map[Long, Set[Troop]]

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

  def apply(location: Location, planetOwner: Option[Player],
            players: Set[Option[Player]],
            allianceNames: Combat.AllianceNames,
            napRules: NapRules, troops: Set[Troop],
            loadedTroops: Combat.LoadedTroops,
            unloadedTroopIds: Set[Long],
            buildings: Set[Building]) =
    new Combat(location, planetOwner, players, allianceNames, napRules,
               troops, loadedTroops, unloadedTroopIds, buildings)
}

/**
 * Combat simulator.
 */
class Combat(location: Location, planetOwner: Option[Player],
             players: Set[Option[Player]],
             allianceNames: Combat.AllianceNames,
             napRules: Combat.NapRules,
             troops: Set[Troop],
             loadedTroops: Combat.LoadedTroops,
             unloadedTroopIds: Set[Long],
             buildings: Set[Building]) {
  // Units unloaded to ground, and those who are still kept in their
  // transporters.
  val (unloadedTroops, stillLoadedTroops) = {
    var unloaded = Map[Long, Set[Troop]]()
    var retained = Map[Long, Set[Troop]]()

    loadedTroops.foreach { case (transporterId, transporterTroops) =>
      val (transporterUnloaded, transporterRetained) =
        transporterTroops.partition { t => unloadedTroopIds.contains(t.id) }
      unloaded = unloaded.updated(transporterId, transporterUnloaded)
      retained = retained.updated(transporterId, transporterRetained)
    }

    (unloaded, retained)
  }
  
  /**
   * Log of this combat.
   *
   * If there is any units to unload and we are in planet they are unloaded
   * as a first tick.
   */
  val log = {
    L.debug("%d troops unloaded".format(unloadedTroopIds.size))
    val groupedUnloadedTroopIds =
      if (unloadedTroopIds.isEmpty) Map.empty[Long, Seq[Long]]
      else unloadedTroops.map {
        case (transporterId, troops) =>
          transporterId -> troops.map { _.id }.toSeq
      }
    
    new Log(groupedUnloadedTroopIds)
  }

  // Only include loaded troops if we are in planet.
  private val combatants = troops ++ buildings ++ 
    unloadedTroops.values.flatten

  /**
   * Map of alliance id => alliance and player id => alliance id.
   */
  val alliances = Alliances(planetOwner, players, allianceNames, napRules,
                            combatants)
  // Generate JSON representation before running combat because after combat all
  // HP properties will be changed.
  alliances.toMap

  val statistics = new Statistics(alliances)

  // Launch the combat in the constructor.
  L.debug("Running combat simulation", () => run())

  /**
   * Map of player -> outcome pairs.
   */
  val outcomes = new Outcomes(alliances)

  /**
   * Yours/Alliance/Nap/Enemy alive/dead counts calculator.
   *
   * Also pass troops still loaded in transporters to
   * calculator so it could report units killed with transporter.
   */
  val yane = new YANECalculator(alliances, combatants, stillLoadedTroops)

  val classifiedAlliances = new AlliancesClassifier(alliances)

  /**
   * Simulate this combat.
   */
  private def run() {
    val ticks = Config.combatRoundTicks
    ticks.times { tickIndex =>
      L.debug("Running tick %d/%d".format(tickIndex + 1, ticks), () => {
        // Reset initiative lists if this is not the first tick
        if (tickIndex != 0) alliances.reset()

        val tick = simulateTick()

        if (tick.isEmpty) {
          L.debug("Empty tick, ending simulation.")
          return
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

  private def shootGuns(allianceId: Long, combatant: Combatant) = {
    val fire = new Log.Tick.Fire(combatant)

    combatant.guns.foreach { gun =>
      L.debug("Shooting %s".format(gun), () =>
        alliances.targetFor(allianceId, gun) match {
          case Some(target) => {
              val damage = gun.shoot(target)
              // If damage is 0 then this gun is still cooling down.
              if (damage != 0) {
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
          }
          case None => L.debug("No target for this gun!")
        }
      )
    }

    fire
  }
}
