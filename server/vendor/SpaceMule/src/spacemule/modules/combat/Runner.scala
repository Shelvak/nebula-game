package spacemule.modules.combat

import spacemule.helpers.StdErrLog
import spacemule.helpers.json.Json
import spacemule.modules.combat.objects._
import spacemule.modules.pmg.objects.Location
import spacemule.helpers.Converters._
import spacemule.helpers.Benchmarkable
import spacemule.helpers.BenchmarkableMock

object Runner extends BenchmarkableMock {
  private type CombatantMap = Map[String, Any]

  /**
   * Run combat simulation.
   *
   * Input:
   * Map(
   *   "location" -> Map(
   *     "id" -> Int,
   *     "kind" -> Int,
   *     "x" -> Int | null
   *     "y" -> Int | null
   *   ),
   *   "nap_rules" -> Map[allianceId: Int -> napIds: Seq[Int]],
   *   "alliance_names" -> Map[allianceId: Int -> name: String]
   *   "players" -> Map[
   *     Int -> Map(
   *       "alliance_id" -> Int | null,
   *       "name" -> String,
   *       "damage_tech_mods" -> Map(
   *         "Unit::Trooper" -> Double,
   *         ...
   *       ),
   *       "armor_tech_mods" -> Map(
   *         "Unit::Trooper" -> Double,
   *         ...
   *       )
   *     )
   *   ],
   *   "troops" -> Seq[
   *     // This is Troop
   *     Map(
   *       "id" -> Int,
   *       "type" -> String,
   *       "level" -> Int,
   *       "hp" -> Int,
   *       "flank" -> Int,
   *       "player_id" -> Int | null,
   *       "stance" -> Int,
   *       "xp" -> Int
   *     )
   *   ],
   *   "unloaded_troops" -> Map[transporterId: Int, Seq[Troop]],
   *   "planet_owner_id" -> Int | null,
   *   "buildings" -> Seq[
   *     Map(
   *       "id" -> Int,
   *       "type" -> String,
   *       "hp" -> Int,
   *       "level" -> Int
   *     )
   *   ]
   * )
   */
  def run(input: Map[String, Any]): Map[String, Any] = {
    val location = Location.read(
      input.getOrError("location").asInstanceOf[Map[String, Any]]
    )
    val allianceNames = Json.intifyKeys(
      input.getOrError("alliance_names").asInstanceOf[Map[String, String]]
    )
    val napRules = Json.intifyKeys(
      input.getOrError("nap_rules").asInstanceOf[Map[String, Set[Int]]]
    )
    val players = input.getOrError("players").asInstanceOf[
      Map[String, Map[String, Any]]
    ].map { case (playerIdString, data) =>
        val playerId = playerIdString.toInt
        val name = data.getOrError("name").asInstanceOf[String]
        val allianceId = data.getOptOrError("alliance_id").asInstanceOf[
          Option[Int]]
        val technologies = new Player.Technologies(
          data.getOrError("damage_tech_mods").asInstanceOf[Map[String, Double]],
          data.getOrError("armor_tech_mods").asInstanceOf[Map[String, Double]]
        )

        (playerId -> new Player(playerId, name, allianceId, technologies))
    }

    // Check if we have any npcs in this battle.
    var hasNpc = false
    def checkNpc[T <: {def player: Option[Player]}](item: T): T = {
      if (item.player == None) hasNpc = true
      item
    }

    val troops = input.getOrError("troops").
    asInstanceOf[Seq[CombatantMap]].map { 
      data => checkNpc(readTroop(data, players))
    }.toSet

    val unloadedTroops = input.getOrError("unloaded_troops").
    asInstanceOf[Map[Int, Iterable[CombatantMap]]].map {
      case (transporterId, iterable) =>
        val troops = iterable.map { case data =>
          checkNpc(readTroop(data, players))
        }.toSeq
        (transporterId -> troops)
    }

    val planetOwner = location.kind match {
      case Location.Planet => input.getOptOrError("planet_owner_id") match {
          case None => None
          case Some(id: Int) => Some(players(id))
      }
      case _ => None
    }
    val buildings = location.kind match {
      case Location.Planet => input.getOrError("buildings").
        asInstanceOf[Seq[CombatantMap]].map { 
          data => checkNpc(readBuilding(data, planetOwner))
        }.toSet
      case _ => Set.empty[Building]
    }

//    StdErrLog.level = StdErrLog.Debug
    val combat = benchmark("Combat simulation") { () =>
      StdErrLog.debug("Combat simulation", () =>
        Combat(
          location,
          planetOwner,
          (
            players.values.map { Some(_) } ++
            (if (hasNpc) Set(None) else Set.empty)
          ).toSet,
          allianceNames,
          napRules,
          troops,
          unloadedTroops,
          buildings
        )
      )
    }

    printBenchmarkResults()

    if (combat.log.isEmpty)
      Map("no_combat" -> true)
    else
      Map[String, Any](
        "log" -> combat.log.asJson,
        "killed_by" -> combat.alliances.killedBy.asJson,
        "statistics" -> combat.statistics.asJson,
        "outcomes" -> combat.outcomes.asJson,
        "alliances" -> combat.alliances.asJson,
        "classified_alliances" -> combat.classifiedAlliances.asJson,
        "troop_changes" -> (changes(troops) ++ 
                            changes(unloadedTroops.values.flatten)),
        "building_changes" -> changes(buildings),
        "yane" -> combat.yane.asJson
      )
  }

  private def readTroop(data: CombatantMap, players: Map[Int, Player]) =
    new Troop(
      data.getOrError("id").asInstanceOf[Int],
      data.getOrError("type").asInstanceOf[String],
      data.getOrError("level").asInstanceOf[Int],
      data.getOrError("hp").asInstanceOf[Int],
      data.getOptOrError("player_id") match {
        case None => None
        case Some(id: Int) => Some(players(id))
      },
      data.getOrError("flank").asInstanceOf[Int],
      Stance(data.getOrError("stance").asInstanceOf[Int]),
      data.getOrError("xp").asInstanceOf[Int]
    )

  private def readBuilding(data: CombatantMap, owner: Option[Player]) =
    new Building(
      data.getOrError("id").asInstanceOf[Int],
      owner,
      data.getOrError("type").asInstanceOf[String],
      data.getOrError("hp").asInstanceOf[Int],
      data.getOrError("level").asInstanceOf[Int]
    )

  private def changes(items: Iterable[Combatant]) =
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
