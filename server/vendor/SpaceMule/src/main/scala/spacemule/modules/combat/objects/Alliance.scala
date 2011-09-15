package spacemule.modules.combat.objects

import scala.collection.mutable
import scala.collection.immutable._
import spacemule.helpers.Converters._
import spacemule.helpers.{StdErrLog => L}

class Alliance(val id: Long,
               val name: Option[String],
               val players: Set[Option[Player]],
               combatants: Set[Combatant]) {
  private val (groundFlanks, spaceFlanks) = {
    val (ground, space) = combatants.partition { _.isGround }
    (new Flanks("ground", ground), new Flanks("space", space))
  }

  /**
   * Returns active combatants from space and ground unit lists by their
   * initiative.
   */
  def take(initiative: Int) = Set(
    groundFlanks.take(initiative), spaceFlanks.take(initiative)
  ).flatten

  /**
   * Initiatives in this alliance.
   */
  def initiatives = Set(
    groundFlanks.initiatives, spaceFlanks.initiatives
  ).flatten

  /**
   * Returns combatant that you can shoot or None if no such combatant exists.
   */
  def target(gun: Gun): Option[Combatant] = flanks(gun.kind).target(gun.damage)

  /**
   * Returns flanks for given kind.
   */
  private def flanks(kind: Kind.Value) = kind match {
    case Kind.Ground => groundFlanks
    case Kind.Space => spaceFlanks
  }

  /**
   * Kills target and removes it from alive flanks.
   */
  def kill(target: Combatant) = flanks(target.kind).kill(target)

  /**
   * Reset ground and space initiative lists.
   */
  def reset() = {
    L.debug("Resetting alliance (id: %d) initiative lists".format(id))
    groundFlanks.reset()
    spaceFlanks.reset()
  }

  /**
   * Is this alliance still alive?
   */
  def isAlive = groundFlanks.hasAlive || spaceFlanks.hasAlive

  /**
   * Is this player still alive?
   */
  def isAlive(player: Option[Player]) =
    groundFlanks.isAlive(player) || spaceFlanks.isAlive(player)

  /**
   * Returns JSON representation.
   *
   * Map(
   *   "name" -> String | null,
   *   "players" -> Seq[Seq(id: Int, name: String) | null],
   *   "flanks" -> Map(flankIndex: Int, flank: Map(
   *     "ground" -> Seq[Combatant], "space" -> Seq[Combatant]
   *   ))
   * )
   */
  def toMap: Map[String, Any] = {
    val groundFlanksMap = groundFlanks.asJson
    val spaceFlanksMap = spaceFlanks.asJson

    val flanks = (groundFlanksMap.keySet ++ spaceFlanksMap.keySet).map {
      case flankIndex =>
        flankIndex -> Map(
          "ground" -> groundFlanksMap.getOrElse(flankIndex, Set.empty),
          "space" -> spaceFlanksMap.getOrElse(flankIndex, Set.empty)
        )
    }.toMap

    Map(
      "name" -> (name match {
        case Some(string) => string
        case None => null
      }),
      "players" -> playersAsMapData,
      "flanks" -> flanks
    )
  }

  /**
   * Seq[Seq(id: Int, name: String) | null]
   */
  def playersAsMapData = players.map { _ match {
    case Some(player) => Seq(player.id, player.name)
    case None => null
  } }
}
