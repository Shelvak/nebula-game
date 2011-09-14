package spacemule.modules.combat.post_combat

import spacemule.modules.combat.objects._

object Classification extends Enumeration {
  val Friend = Value(0, "friend")
  val Enemy = Value(1, "enemy")
  val Nap = Value(2, "nap")
}

object AlliancesClassifier {
  type ClassificationMap = Map[Int, Map[Int, Map[String, Any]]]
}

/**
 * Classifies all alliances from player perspectives.
 */
class AlliancesClassifier(alliances: Alliances) {
  /**
   * Map(
   *   playerId: Int -> Map(
   *     allianceId: Int -> Map(
   *       "name" -> String | null,
   *       "classification" -> Int,
   *       "players" -> Seq[(id: Int, name: String) | null]
   *     )
   *   )
   * )
   */
  lazy val toMap: AlliancesClassifier.ClassificationMap = {
    alliances.alliancesMap.map {
      case (allianceId, alliance) =>
        alliance.players.map {
          _ match {
            // NPC players don't need this info.
            case None => None
            case Some(player) => {
                val perspectives = alliances.alliancesMap.map {
                  case (allianceId, alliance) =>
                    view(alliances, player, alliance)
                }

                Some(player.id -> perspectives)
            }
          }
        }.flatten
    }.flatten.toMap
  }

  /**
   * View of the player of this alliance.
   */
  private def view(alliances: Alliances, player: Player,
                alliance: Alliance) = {
    val classification =
      if (alliances.isFriend(Some(player), alliance.id))
        Classification.Friend
      else if (alliances.isEnemy(Some(player), alliance.id))
        Classification.Enemy
      else
        Classification.Nap

    val allianceMap = Map(
      "name" -> alliance.name.getOrElse(null),
      "classification" -> classification.id,
      "players" -> alliance.playersAsJson
    )

    (alliance.id -> allianceMap)
  }
}
