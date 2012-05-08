package spacemule.modules.combat

import spacemule.logging.Log
import spacemule.modules.combat.objects._
import spacemule.helpers.Converters._
import post_combat._

object Runner {
  /**
   * Maps attribute changes (ID -> Map[attribute -> newValue]).
   */
  type ChangesMap = Map[Long, Map[String, Any]]

  case class Response(
    log: Map[String, Any],
    killedBy: KilledBy.DataMap,
    statistics: Statistics.PlayerDataMap,
    outcomes: Outcomes.PlayerMap,
    alliances: Alliances.DataMap,
    classifiedAlliances: AlliancesClassifier.ClassificationMap,
    troopChanges: ChangesMap,
    buildingChanges: ChangesMap,
    yane: YANECalculator.DataMap
  )

  private type CombatantMap = Map[String, Any]

  /**
   * Run combat simulation.
   **/
  def run(
    location: Location,
    isBattleground: Boolean,
    planetOwner: Option[Player],
    players: Set[Option[Player]],
    allianceNames: Combat.AllianceNames,
    napRules: Combat.NapRules,
    troops: Set[Troop],
    loadedTroops: Map[Long, Set[Troop]],
    unloadedTroopIds: Set[Long],
    buildings: Set[Building]
  ): Option[Response] = {
    val combat = Log.block("Combat simulation", level=Log.Debug) { () =>
      Combat(
        location,
        isBattleground,
        planetOwner,
        players,
        allianceNames,
        napRules,
        troops,
        loadedTroops,
        unloadedTroopIds,
        buildings
      )
    }

    if (combat.log.isEmpty && combat.outcomes.isTie) {
      // There was not combat if all sides have alive enemies and there were
      // no shots fired. Probably different reaches.
      None
    }
    else {
      Some(Response(
        combat.log.toMap,
        combat.alliances.killedBy.toMap,
        combat.statistics.byPlayer,
        combat.outcomes.byPlayer,
        combat.alliances.toMap,
        combat.classifiedAlliances.toMap,
        (changes(troops) ++ changes(loadedTroops.values.flatten)),
        changes(buildings),
        combat.yane.toMap
      ))
    }
  }

  private def changes(items: Iterable[Combatant]): ChangesMap =
    items.map { item =>
      val changes = item.changes
      if (changes.isEmpty) None 
      else {
        val newValues = changes.map { case (attribute, (oldValue, newValue)) =>
            (attribute -> newValue)
        }
        Some(item.id -> newValues)
      }
    }.flatten.toMap
}
