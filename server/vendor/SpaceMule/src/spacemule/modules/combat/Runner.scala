package spacemule.modules.combat

import spacemule.helpers.StdErrLog
import spacemule.modules.combat.objects._
import spacemule.modules.pmg.objects.Location
import spacemule.helpers.Converters._
import spacemule.helpers.Benchmarkable

object Runner extends Benchmarkable {
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
   *   "nap_rules" -> Map[allianceId: Int, napIds: Seq[Int]],
   *   "players" -> Map[
   *     Int -> Map(
   *       "alliance_id" -> Int | null,
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
   *   "unloaded_troops" -> Map[transporterId: Int, Troop],
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
    val napRules = input.getOrError("nap_rules").asInstanceOf[Combat.NapRules]
    val players = input.getOrError("players").asInstanceOf[
      Map[String, Map[String, Any]]
    ].map { case (playerIdString, data) =>
        val playerId = playerIdString.toInt
        val allianceId = data.getOptOrError("alliance_id").asInstanceOf[
          Option[Int]]
        val technologies = new Player.Technologies(
          data.getOrError("damage_tech_mods").asInstanceOf[Map[String, Double]],
          data.getOrError("armor_tech_mods").asInstanceOf[Map[String, Double]]
        )

        (playerId -> new Player(playerId, allianceId, technologies))
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
    asInstanceOf[Map[Int, CombatantMap]].map { case (transporterId, data) =>
        (transporterId -> checkNpc(readTroop(data, players)))
    }

    val planetOwner = location.kind match {
      case Location.Planet => input.getOptOrError("planet_owner_id") match {
          case None => None
          case Some(id: Int) => Some(players(id))
      }
      case _ => error("There can be no buildings in %s!".format(location))
    }
    val buildings = location.kind match {
      case Location.Planet => input.getOrError("buildings").
        asInstanceOf[Seq[CombatantMap]].map { 
          data => checkNpc(readBuilding(data, planetOwner))
        }.toSet
      case _ => error("There can be no buildings in %s!".format(location))
    }

    StdErrLog.level = StdErrLog.Debug
    val combat = benchmark("Combat simulation") { () =>
      StdErrLog.debug("Combat simulation", () =>
        Combat(
          location,
          (
            players.values.map { Some(_) } ++
            (if (hasNpc) Set(None) else Set.empty)
          ).toSet,
          napRules,
          troops,
          unloadedTroops,
          buildings
        )
      )
    }

    println(combat.statistics)
    println(combat.outcomes)

    printBenchmarkResults()

    Map()
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
}
