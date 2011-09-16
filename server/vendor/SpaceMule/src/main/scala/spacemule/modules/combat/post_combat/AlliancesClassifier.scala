package spacemule.modules.combat.post_combat

import spacemule.modules.combat.objects._

object Classification extends Enumeration {
  val Friend = Value(0, "friend")
  val Enemy = Value(1, "enemy")
  val Nap = Value(2, "nap")
}

object AlliancesClassifier {
  // Map[key, value]
  type Perspective = Map[String, Any]
  // alliance id -> entry map
  type Entry = Map[Long, Perspective]
  // player id -> entry
  type ClassificationMap = Map[Long, Entry]
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
      case (_, alliance) =>
        alliance.players.map {
          _ match {
            // NPC players don't need this info.
            case None => None
            case Some(player) => {
                val perspectives: AlliancesClassifier.Entry =
                  alliances.alliancesMap.map {
                    case (allianceId, allianceInPerspective) =>
                      allianceId -> view(
                        alliances, player, allianceInPerspective
                      )
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
                alliance: Alliance): AlliancesClassifier.Perspective = {
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
      "players" -> alliance.playersAsMapData
    )

    allianceMap
  }
}
