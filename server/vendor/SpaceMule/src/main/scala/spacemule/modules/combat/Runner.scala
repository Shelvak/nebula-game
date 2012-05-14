package spacemule.modules.combat

import spacemule.logging.Log
import spacemule.modules.combat.objects._
import spacemule.helpers.Converters._
import spacemule.helpers.JRuby._
import post_combat._
import org.jruby.runtime.builtin.IRubyObject
import org.jruby.RubyHash
import org.jruby.javasupport.JavaUtil
import org.jruby.runtime.Block
import scala.{collection => sc}

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
    rbPlayers: IRubyObject, // Set[Option[Player]],
    rbAllianceNames: RubyHash, // Combat.AllianceNames
    rbNapRules: RubyHash, // Combat.NapRules,
    rbTroops: IRubyObject, // Set[Troop],
    rbLoadedTroops: RubyHash, // Map[Long, Set[Troop]],
    rbUnloadedTroopIds: IRubyObject, // Set[Long],
    rbBuildings: IRubyObject // Set[Building]
  ): Option[Response] = {
    val players = rbPlayers.asSet[Option[Player]](
      obj => obj.unwrap[Option[Player]], opt => opt
    )
    val allianceNames = rbAllianceNames.asMap[Long, String](
      obj => obj.asLong, obj => obj.toString,
      long => long, string => string
    )
    val napRules = rbNapRules.asMap[Long, sc.Set[Long]](
      obj => obj.asLong,
      obj => obj.asSet[Long](obj => obj.asLong, long => long),
      long => long, set => RSet(set)
    )
    val troops = rbTroops.asSet[Troop](
      obj => obj.unwrap[Troop], troop => troop
    )
    val loadedTroops = rbLoadedTroops.asMap[Long, sc.Set[Troop]](
      obj => obj.asLong,
      obj => obj.asSet[Troop](obj => obj.unwrap[Troop], troop => troop),
      long => long, set => RSet(set)
    )
    val unloadedTroopIds = rbUnloadedTroopIds.
      asSet[Long](obj => obj.asLong, long => long)
    val buildings = rbBuildings.
      asSet[Building](obj => obj.unwrap[Building], b => b)

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
