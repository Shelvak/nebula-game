package spacemule.modules.combat.objects

import scala.collection.mutable
import scala.collection.immutable._
import spacemule.helpers.Converters._
import spacemule.helpers.{StdErrLog => L}

class Alliance(val id: Int,
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
    groundFlanks.reset
    spaceFlanks.reset
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
   *   "players" -> Seq[(id: Int, name: String) | null],
   *   "flanks" -> Map(
   *     "ground" -> Flanks,
   *     "space" -> Flanks
   *   )
   * )
   */
  def asJson: Map[String, Any] = Map(
    "name" -> (name match {
      case Some(name) => name
      case None => null
    }),
    "players" -> playersAsJson,
    "flanks" -> Map(
      "ground" -> groundFlanks.asJson,
      "space" -> spaceFlanks.asJson
    )
  )

  /**
   * Seq[(id: Int, name: String) | null]
   */
  def playersAsJson = players.map { _ match {
    case Some(player) => (player.id, player.name)
    case None => null
  } }
}
